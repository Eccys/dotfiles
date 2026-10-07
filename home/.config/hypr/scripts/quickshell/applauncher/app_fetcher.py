#!/usr/bin/env python3
import os
import glob
import json

def fetch_apps():
    apps = {}
    home = os.path.expanduser('~')
    
    # Expanded directories to catch Flatpaks, system apps, and Nix packages
    dirs = [
        '/usr/share/applications',
        '/usr/local/share/applications',
        f'{home}/.local/share/applications',
        '/var/lib/flatpak/exports/share/applications',
        f'{home}/.local/share/flatpak/exports/share/applications',
        f'{home}/.nix-profile/share/applications',
        '/run/current-system/sw/share/applications'
    ]
    
    for d in dirs:
        if not os.path.exists(d):
            continue
            
        for f in glob.glob(os.path.join(d, '**/*.desktop'), recursive=True):
            try:
                with open(f, 'r', encoding='utf-8') as file:
                    app = {'name': '', 'exec': '', 'icon': ''}
                    is_desktop = False
                    no_display = False
                    
                    for line in file:
                        line = line.strip()
                        if line == '[Desktop Entry]':
                            is_desktop = True
                        elif line.startswith('['):
                            is_desktop = False
                            
                        if is_desktop:
                            if line.startswith('Name=') and not app['name']:
                                app['name'] = line[5:]
                            elif line.startswith('Exec=') and not app['exec']:
                                # Strip %u, %f, and @@ placeholders
                                app['exec'] = line[5:].split(' %')[0].split(' @@')[0]
                            elif line.startswith('Icon=') and not app['icon']:
                                app['icon'] = line[5:]
                            elif line.startswith('NoDisplay=true') or line.startswith('NoDisplay=1'):
                                no_display = True
                                
                    filename = os.path.basename(f)
                    if app['name'] and app['exec']:
                        if no_display:
                            if filename in apps:
                                del apps[filename]
                            # Or if it doesn't exist yet, we still record it as hidden
                            # so if a later directory has it (though dirs are sorted from system to local),
                            # it stays hidden. Actually, we should just key by filename.
                            apps[filename] = {'hidden': True}
                        else:
                            apps[filename] = app
            except Exception:
                pass
                
    # Sort alphabetically, filter out hidden, and return as JSON
    res = [app for app in apps.values() if not app.get('hidden')]
    res.sort(key=lambda x: x['name'].lower())
    print(json.dumps(res))

if __name__ == "__main__":
    fetch_apps()

