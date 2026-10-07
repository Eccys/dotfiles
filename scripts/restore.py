#!/usr/bin/env python3
"""Restore the declared Arch desktop. Default invocation only prints the plan."""
import argparse
import base64
import datetime
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess as sp
import sys
import tempfile
import urllib.request

REPO = Path(__file__).resolve().parents[1]
STEPS = ['packages','configs','system','snapshots','browser','wallpapers','plugins']

def run(args, **kwargs):
    print('+', ' '.join(map(str,args)), flush=True)
    return sp.run(list(map(str,args)), check=True, **kwargs)

def read_packages(name):
    return sorted(set(line.strip() for line in (REPO/'packages'/name).read_text().splitlines() if line.strip() and not line.startswith('#')))

class Restore:
    def __init__(self,args):
        self.args=args
        self.home=Path(args.target_home or Path.home()).resolve()
        if any(c in str(self.home) for c in "\n\r'\" "):
            raise SystemExit('Use a conventional home path without spaces or quote characters.')
        self.live=self.home==Path.home().resolve()
        self.backup=self.home/'.local/state/eccys-restore'/datetime.datetime.now().strftime('%Y%m%dT%H%M%S')
        self.saved=set()

    def backup_file(self,path):
        if path in self.saved:return
        self.saved.add(path)
        if not path.exists() and not path.is_symlink():return
        rel=str(path).lstrip('/')
        dst=self.backup/rel
        dst.parent.mkdir(parents=True,exist_ok=True,mode=0o700)
        if path.is_symlink():dst.symlink_to(os.readlink(path))
        elif path.is_dir():shutil.copytree(path,dst,symlinks=True)
        else:shutil.copy2(path,dst)

    def real_parents(self,path):
        parents=[];p=path.parent
        while p!=self.home and self.home in p.parents:
            parents.append(p);p=p.parent
        for p in reversed(parents):
            if p.is_symlink():
                self.backup_file(p);target=p.resolve();p.unlink()
                if target.is_dir():shutil.copytree(target,p,symlinks=True)
                else:p.mkdir()
            elif p.exists() and not p.is_dir():raise RuntimeError(f'Parent is a file: {p}')
            else:p.mkdir(exist_ok=True)

    def install_file(self,src,dst):
        self.real_parents(dst)
        if src.suffix=='.b64':data=base64.b64decode(src.read_text(),validate=False)
        else:data=src.read_text().replace('@HOME@',str(self.home)).encode()
        modes=json.loads((REPO/'manifest.json').read_text()).get('modes',{})
        mode=modes.get(str(src.relative_to(REPO)),0o644)
        if dst.is_file() and not dst.is_symlink() and dst.read_bytes()==data:
            dst.chmod(mode);return
        self.backup_file(dst)
        if dst.is_symlink():dst.unlink()
        dst.write_bytes(data)
        modes=json.loads((REPO/'manifest.json').read_text()).get('modes',{})
        mode=modes.get(str(src.relative_to(REPO)),0o644)
        dst.chmod(mode)

    def packages(self):
        if not self.live:raise RuntimeError('Package/system operations require the current login home.')
        os_release=Path('/etc/os-release').read_text()
        if 'ID=arch' not in os_release and 'ID="arch"' not in os_release:
            raise RuntimeError('This restore target is Arch Linux.')
        if os.geteuid()==0:raise RuntimeError('Run as the desktop user; sudo is used only for system changes.')
        run(['sudo','-v'])
        # Enable multilib without replacing repository/mirror choices.
        config=Path('/etc/pacman.conf').read_text()
        if '[multilib]\nInclude' not in config:
            changed=config.replace('#[multilib]\n#Include = /etc/pacman.d/mirrorlist','[multilib]\nInclude = /etc/pacman.d/mirrorlist')
            if changed==config:raise RuntimeError('Enable [multilib] in /etc/pacman.conf before installing Steam/Wine.')
            run(['sudo','cp','-a','/etc/pacman.conf','/etc/pacman.conf.before-eccys-restore'])
            with tempfile.NamedTemporaryFile(mode='w') as f:
                f.write(changed);f.flush();run(['sudo','install','-m','644',f.name,'/etc/pacman.conf'])
        run(['sudo','pacman','-Syu','--needed','--noconfirm',*read_packages('official.txt')])
        build=self.home/'.cache/eccys-restore/aur'
        build.mkdir(parents=True,exist_ok=True)
        for package in read_packages('aur.txt'):
            # Keep an already installed package. The recorded versions are an
            # audit baseline; this is not a cross-repository downgrade tool.
            if sp.run(['pacman','-Q',package],stdout=sp.DEVNULL,stderr=sp.DEVNULL).returncode==0:continue
            source=REPO/'vendor/aur'/package
            if not (source/'PKGBUILD').exists():raise RuntimeError(f'No reviewed AUR recipe for {package}')
            target=build/package
            shutil.copytree(source,target,dirs_exist_ok=True)
            run(['makepkg','-si','--needed','--noconfirm'],cwd=target)
        self.serpantinum_package()

    def serpantinum_package(self):
        build=self.home/'.cache/eccys-restore/serpantinum'
        build.mkdir(parents=True,exist_ok=True)
        source=REPO/'packages/serpantinum'
        shutil.copytree(source,build,dirs_exist_ok=True)
        shutil.copytree(REPO/'vendor/serpantinum',build/'overlay',dirs_exist_ok=True)
        run(['makepkg','-si','--needed','--noconfirm'],cwd=build)

    def configs(self):
        self.home.mkdir(parents=True,exist_ok=True)
        for name in ['Desktop','Downloads','Documents','Music','Pictures','Pictures/sss','Pictures/Wallpapers','Videos','Templates','Public','Projects']:(self.home/name).mkdir(parents=True,exist_ok=True)
        for src in sorted((REPO/'home').rglob('*')):
            if not src.is_file() or src.name.startswith('dconf-') or '__pycache__' in src.parts or src.suffix=='.pyc':continue
            relative=src.relative_to(REPO/'home')
            if src.suffix=='.b64':relative=relative.with_suffix('')
            self.install_file(src,self.home/relative)
        shell=self.home/'.local/share/serpantinum'
        if self.live and Path('/usr/share/serpantinum').is_dir():
            if shell.is_symlink():
                if shell.resolve()!=Path('/usr/share/serpantinum'):
                    self.backup_file(shell);shell.unlink()
            elif shell.exists():
                self.backup_file(shell);shutil.rmtree(shell)
            if not shell.exists():shell.symlink_to('/usr/share/serpantinum',target_is_directory=True)
            for name in ['serpantinum','serpantinumd']:
                dest=self.home/'.local/bin'/name
                if dest.exists() or dest.is_symlink():self.backup_file(dest);dest.unlink()
                dest.symlink_to('/usr/bin/'+name)
        if self.live:
            for name,path in [('nautilus','/org/gnome/nautilus/'),('interface','/org/gnome/desktop/interface/')]:
                with (REPO/'home'/f'dconf-{name}.ini').open('rb') as f:run(['dconf','load',path],stdin=f)
            run(['systemctl','--user','daemon-reload'])
            for unit in ['serpantinum.service','lianli-daemon.service','eccys-weather.timer','gnome-keyring-daemon.socket','pipewire.socket','pipewire-pulse.socket']:
                run(['systemctl','--user','enable',unit])
            run(['update-desktop-database',self.home/'.local/share/applications'])
        print('Managed config backup:',self.backup)

    def system(self):
        if not self.live:raise RuntimeError('System operations require the current login home.')
        # Storage/boot and broad privilege policy are deliberately templated in
        # docs, not copied across hosts. Only this allowlist is applied here.
        allowed=['keyd/default.conf','sddm.conf.d/10-material-you.conf','profile.d/archprep-editor.sh','apparmor.d/chatgpt','apparmor.d/grok-bot']
        for name in allowed:
            source=REPO/'system/etc'/name
            if not source.exists():continue
            dest=Path('/etc')/name
            if dest.exists():
                backup=self.backup/'system'/dest.relative_to('/')
                run(['sudo','mkdir','-p',backup.parent]);run(['sudo','cp','-a',dest,backup])
            with tempfile.NamedTemporaryFile(mode='w') as tmp:
                tmp.write(source.read_text().replace('@HOME@',str(self.home)));tmp.flush()
                run(['sudo','install','-Dm644',tmp.name,dest])
        helper=REPO/'system/usr/local/sbin/update-keyd-credential-macros'
        import pwd
        with tempfile.NamedTemporaryFile(mode='w') as tmp:
            tmp.write(helper.read_text().replace('@HOME@',str(self.home)).replace('@USER@',pwd.getpwuid(os.getuid()).pw_name));tmp.flush()
            run(['sudo','install','-Dm755',tmp.name,'/usr/local/sbin/update-keyd-credential-macros'])
        # Grant only the fixed commands needed by the two local helpers.
        user=pwd.getpwuid(os.getuid()).pw_name
        commands=[('/usr/bin/snapper -c '+name+' create --type single --cleanup-algorithm number --description Manual '+name+' snapshot --print-number') for name in ['root','home']]
        commands.append('/usr/local/sbin/update-keyd-credential-macros ""')
        with tempfile.NamedTemporaryFile(mode='w') as tmp:
            tmp.write(user+' ALL=(root) NOPASSWD: '+', '.join(commands)+'\n');tmp.flush()
            run(['sudo','visudo','-cf',tmp.name]);run(['sudo','install','-Dm440',tmp.name,'/etc/sudoers.d/eccys-desktop-helpers'])
        # Restore the theme from versioned assets, preserving its layout.
        theme=REPO/'vendor/sddm'
        if theme.exists():
            run(['sudo','mkdir','-p','/usr/share/sddm/themes/material-you'])
            for src in theme.rglob('*'):
                if src.is_file():
                    dst=Path('/usr/share/sddm/themes/material-you')/src.relative_to(theme)
                    if src.suffix=='.b64':dst=dst.with_suffix('')
                    with tempfile.NamedTemporaryFile() as tmp:
                        data=base64.b64decode(src.read_text()) if src.suffix=='.b64' else src.read_bytes()
                        tmp.write(data);tmp.flush();run(['sudo','install','-Dm644',tmp.name,dst])
        for unit in ['NetworkManager.service','bluetooth.service','keyd.service','sddm.service']:
            run(['sudo','systemctl','enable',unit])
        # Existing live desktop processes are not restarted during deployment.

    def snapshots(self):
        if not self.live:raise RuntimeError('Snapshot setup requires the current login home.')
        for name,mount in [('root','/'),('home','/home')]:
            kind=sp.check_output(['findmnt','-n','-o','FSTYPE','-T',mount],text=True).strip()
            if kind!='btrfs':raise RuntimeError(f'{mount} is {kind}; create the documented Btrfs layout first.')
            config=Path('/etc/snapper/configs')/name
            if not config.exists():
                # create-config is used only when it can create .snapshots. If
                # an independently mounted snapshot subvolume already exists,
                # install/register its config without deleting that mount.
                snapshots=Path(mount)/'.snapshots'
                if not snapshots.exists():run(['sudo','snapper','-c',name,'create-config',mount])
                else:run(['sudo','btrfs','subvolume','show',snapshots],stdout=sp.DEVNULL)
            if config.exists():
                backup=self.backup/'system'/config.relative_to('/')
                run(['sudo','mkdir','-p',backup.parent]);run(['sudo','cp','-a',config,backup])
            run(['sudo','install','-Dm640',REPO/'system/etc/snapper/configs'/name,config])
        # SNAPPPER_CONFIGS is required by the distribution timer wrapper.
        path=Path('/etc/conf.d/snapper')
        content=path.read_text() if path.exists() else ''
        import re
        old=re.search(r'^SNAPPER_CONFIGS=["\']([^"\']*)',content,re.M)
        names=set(old[1].split()) if old else set()
        names.update(['root','home'])
        line='SNAPPER_CONFIGS="'+' '.join(sorted(names))+'"'
        content=re.sub(r'^SNAPPER_CONFIGS=.*$',line,content,flags=re.M) if old else content+'\n'+line+'\n'
        with tempfile.NamedTemporaryFile(mode='w') as tmp:
            tmp.write(content);tmp.flush();run(['sudo','install','-Dm644',tmp.name,path])
        run(['sudo','systemctl','enable','--now','snapper-timeline.timer','snapper-cleanup.timer'])
        run(['sudo','snapper','list-configs'])
        # Verify the actual requested behavior, rather than just copying files.
        for name in ['root','home']:
            run(['sudo','snapper','-c',name,'create','--type','single','--cleanup-algorithm','number','--description','Restore verification','--print-number'])

    def browser(self):
        root=self.home/'.config/zen'
        import configparser
        ini=configparser.ConfigParser()
        if (root/'profiles.ini').exists():ini.read(root/'profiles.ini')
        profiles=[s for s in ini.sections() if s.startswith('Profile')]
        selected=next((s for s in profiles if ini[s].get('Default')=='1'),profiles[0] if profiles else None)
        if selected:
            path=Path(ini[selected]['Path'])
            profile=root/path if ini[selected].get('IsRelative')=='1' else path
        else:
            profile=root/'eccys-restore';profile.mkdir(parents=True,exist_ok=True)
            root.mkdir(parents=True,exist_ok=True)
            self.backup_file(root/'profiles.ini')
            (root/'profiles.ini').write_text('[General]\nStartWithLastProfile=1\nVersion=2\n\n[Profile0]\nName=Eccys\nIsRelative=1\nPath=eccys-restore\nDefault=1\n')
        self.install_file(REPO/'browser/user.js',profile/'user.js')
        for source in (REPO/'browser/chrome').rglob('*'):
            if source.is_file():self.install_file(source,profile/'chrome'/source.relative_to(REPO/'browser/chrome'))
        extensions=profile/'extensions';extensions.mkdir(parents=True,exist_ok=True)
        for addon in json.loads((REPO/'browser/extensions.json').read_text()):
            url=addon.get('source')
            if not url and addon['id'].endswith(('@mozilla.org','@mozilla.com')):continue
            if not url or not url.startswith('https://addons.mozilla.org/'):
                raise RuntimeError(f'No trusted download URL for {addon["name"]}')
            dest=extensions/(addon['id']+'.xpi')
            if dest.exists():continue
            with urllib.request.urlopen(url,timeout=60) as result:data=result.read()
            if not data.startswith(b'PK'):raise RuntimeError(f'Not an extension archive: {addon["name"]}')
            # Verify the downloaded extension identifies itself correctly.
            import io,zipfile
            with zipfile.ZipFile(io.BytesIO(data)) as archive:
                manifest=json.loads(archive.read('manifest.json'))
                ident=manifest.get('browser_specific_settings',manifest.get('applications',{})).get('gecko',{}).get('id')
                if ident and ident!=addon['id']:raise RuntimeError('Extension identity mismatch')
            dest.write_bytes(data)
        print('Zen profile prepared:',profile,'(restart Zen after applying)')

    def wallpapers(self):
        directory=self.home/'Pictures/Wallpapers';directory.mkdir(parents=True,exist_ok=True)
        for image in json.loads((REPO/'packages/wallpapers.json').read_text()):
            dest=directory/image['name']
            if dest.is_file() and hashlib.sha256(dest.read_bytes()).hexdigest()==image['sha256']:continue
            with urllib.request.urlopen(image['url'],timeout=60) as result:data=result.read()
            if hashlib.sha256(data).hexdigest()!=image['sha256']:raise RuntimeError('Wallpaper checksum mismatch: '+image['name'])
            self.backup_file(dest);dest.write_bytes(data)
        print('Wallpaper library restored:',directory)

    def plugins(self):
        if not self.live:raise RuntimeError('Plugin deployment requires the current login home.')
        commit='33bc116426c64deefed72f690524aeabb260ba27'
        build=self.home/'.cache/eccys-restore/Equicord'
        build.parent.mkdir(parents=True,exist_ok=True)
        if not (build/'.git').exists():run(['git','clone','https://github.com/Equicord/Equicord.git',build])
        run(['git','checkout','--detach',commit],cwd=build)
        shutil.copytree(REPO/'vendor/equicord/baseDecoder',build/'src/equicordplugins/baseDecoder',dirs_exist_ok=True)
        pnpm=['npm','exec','--yes','--package=pnpm@12.8.1','--','pnpm']
        run(pnpm+['install','--frozen-lockfile'],cwd=build)
        run(pnpm+['build'],cwd=build)
        artifact=build/'dist/equibop.asar'
        if not artifact.is_file():raise RuntimeError('Equicord build did not produce equibop.asar')
        run(['equicord-installer','-install','-branch','canary'])
        dest=self.home/'.config/Equicord/equicord.asar'
        dest.parent.mkdir(parents=True,exist_ok=True);self.backup_file(dest);shutil.copy2(artifact,dest)
        print('Custom Equicord installed; restart Discord when convenient to load it.')

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--apply',action='store_true',help='Apply the restore plan')
    parser.add_argument('--only',help='Comma-separated stages: '+','.join(STEPS))
    parser.add_argument('--target-home',help='Isolated config/browser test target; system stages require your login home')
    parser.add_argument('--verify',action='store_true',help='Run read-only live checks')
    args=parser.parse_args()
    if args.verify:
        return run([sys.executable,REPO/'scripts/verify.py'])
    steps=args.only.split(',') if args.only else STEPS
    if set(steps)-set(STEPS):parser.error('Unknown restore stage')
    print('Restore stages:',', '.join(steps))
    print('Official packages:',len(read_packages('official.txt')),'AUR packages:',len(read_packages('aur.txt')))
    print('Target home:',args.target_home or str(Path.home()))
    print('Boot, partitioning, account creation, private credentials and VM disks: see docs.')
    if not args.apply:
        print('Plan only. Run ./install.sh --apply to execute, or --only configs for one stage.')
        return
    restore=Restore(args)
    for step in steps:
        print('\nApplying',step,flush=True)
        getattr(restore,step)()

if __name__=='__main__':
    try:main()
    except (sp.CalledProcessError,RuntimeError) as error:
        print('Restore stopped:',error,file=sys.stderr)
        sys.exit(1)
