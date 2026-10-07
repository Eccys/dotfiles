#!/usr/bin/env python3
"""Read-only host checks. Missing requirements produce a nonzero exit."""
import json,pathlib,shutil,subprocess as sp,sys
root=pathlib.Path(__file__).resolve().parents[1];failed=[]
def check(label,args):
 p=sp.run(args,stdout=sp.PIPE,stderr=sp.PIPE,text=True)
 print(('PASS' if p.returncode==0 else 'FAIL'),label)
 if p.returncode:failed.append(label)
for name in ['official.txt','aur.txt']:
 for pkg in (root/'packages'/name).read_text().splitlines():check('package '+pkg,['pacman','-Q',pkg])
check('packaged desktop',['pacman','-Q','eccys-serpantinum'])
for unit in ['snapper-timeline.timer','snapper-cleanup.timer']:
 check(unit+' enabled',['systemctl','is-enabled',unit]);check(unit+' active',['systemctl','is-active',unit])
for name in ['root','home']:check('snapshot config '+name,['sudo','-n','snapper','-c',name,'list'])
check('keyd configuration',['sudo','-n','keyd','check','/etc/keyd/default.conf'])
for unit in ['serpantinum.service','lianli-daemon.service']:
 check(unit,['systemctl','--user','is-active',unit])
if shutil.which('hyprctl'):
 p=sp.run(['hyprctl','configerrors'],capture_output=True,text=True)
 if p.returncode or p.stdout.strip():failed.append('Hyprland config');print('FAIL Hyprland config')
 else:print('PASS Hyprland config')
h=pathlib.Path.home()
for name in ['.local/bin/snapx-workflow','.local/bin/snapx-start','.local/share/snapx-workflow/overlay.py','.config/zen/profiles.ini']:
 if not (h/name).is_file():failed.append(name);print('FAIL',name)
 else:print('PASS',name)
print('Live interaction still required: capture/editor/save/clipboard, browser sign-ins, audio, hardware.')
sys.exit(bool(failed))
