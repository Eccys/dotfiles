#!/usr/bin/env python3
import importlib.util,os,pathlib,tempfile,argparse,json
root=pathlib.Path(__file__).resolve().parents[1]
s=importlib.util.spec_from_file_location('restore',root/'scripts/restore.py');m=importlib.util.module_from_spec(s);s.loader.exec_module(m)
with tempfile.TemporaryDirectory(prefix='eccys-restore-test-') as tmp:
 home=pathlib.Path(tmp)/'home';external=pathlib.Path(tmp)/'existing-fish';home.mkdir();external.mkdir();(external/'unmanaged.txt').write_text('keep me',encoding='utf-8');(home/'.config').mkdir()
 try:(home/'.config/fish').symlink_to(external,target_is_directory=True)
 except OSError:
  (home/'.config/fish').mkdir();(home/'.config/fish/unmanaged.txt').write_text('keep me',encoding='utf-8')
 r=m.Restore(argparse.Namespace(target_home=str(home)));r.configs()
 assert not (home/'.config/fish').is_symlink();assert (home/'.config/fish/unmanaged.txt').read_text(encoding='utf-8')=='keep me';assert (external/'unmanaged.txt').read_text(encoding='utf-8')=='keep me'
 config=home/'.config/hypr/hyprland.conf';before=config.read_bytes();r.configs();assert config.read_bytes()==before
 assert (home/'Pictures/Wallpapers/1269318.png').read_bytes().startswith(b'\x89PNG')
 assert (home/'.local/bin/snapx-workflow').stat().st_mode&0o111 or (os.name=='nt' and r.modes.get('home/.local/bin/snapx-workflow',0)&0o111)
 assert '@HOME@' not in (home/'.local/share/applications/io.github.SnapXL.SnapX.desktop').read_text(encoding='utf-8')
 print('PASS: isolated complete config restore, idempotence, home substitution, executable permissions, base64 assets, existing symlink directory contents retained')
