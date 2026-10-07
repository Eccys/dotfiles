#!/usr/bin/env python3
"""Validate the portable restore payload without changing the host."""
import base64,hashlib,json,pathlib,subprocess,sys
root=pathlib.Path(__file__).resolve().parents[1]
manifest=json.loads((root/'manifest.json').read_text())
errors=[]
for name,expected in manifest['sha256'].items():
 p=root/name
 if not p.is_file() or hashlib.sha256(p.read_bytes()).hexdigest()!=expected:errors.append('Checksum: '+name)
for p in root.rglob('*'):
 if not p.is_file() or '.git' in p.parts:continue
 if p.suffix=='.b64':
  try:base64.b64decode(p.read_text().strip(),validate=True)
  except Exception:errors.append('Base64: '+str(p.relative_to(root)))
 if p.suffix=='.json':
  try:json.loads(p.read_text())
  except Exception:errors.append('JSON: '+str(p.relative_to(root)))
for name in (root/'packages/aur.txt').read_text().splitlines():
 if not (root/'vendor/aur'/name/'PKGBUILD').is_file():errors.append('Missing AUR recipe: '+name)
for name in ['official.txt','aur.txt']:
 lines=(root/'packages'/name).read_text().splitlines()
 if len(lines)!=len(set(lines)):errors.append('Duplicate package: '+name)
if errors:print('\n'.join(errors));sys.exit(1)
print('PASS:',len(manifest['sha256']),'payload checksums; JSON/base64 files and package recipes valid')
