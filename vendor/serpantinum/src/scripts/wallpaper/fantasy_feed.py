#!/usr/bin/env python3
"""Demand-driven, deduplicated AI scenery discovery from Wallhaven."""
import concurrent.futures, fcntl, hashlib, json, os, pathlib, subprocess, sys, urllib.parse

def fetch(url):
    return subprocess.check_output(['curl', '--fail', '--silent', '--show-error', '--location', '--max-time', '18', '--retry', '1', url], stderr=subprocess.DEVNULL)

def main():
    cache = pathlib.Path(sys.argv[1]); session = sys.argv[2]
    cache.mkdir(parents=True, exist_ok=True)
    with (cache / 'fantasy.lock').open('w') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        statefile = cache / ('fantasy_' + session + '.json')
        state = json.loads(statefile.read_text()) if statefile.exists() else {'page': 1, 'seen': [], 'seed': '', 'exhausted': False}
        dest = cache / 'search_thumbs'; dest.mkdir(exist_ok=True)
        added = 0
        def inspect(item):
            details = json.loads(fetch('https://wallhaven.cc/api/v1/w/' + item['id']))['data']
            tags = {t['name'].lower() for t in details['tags']}
            scenery = {'landscape', 'scenery', 'mountains', 'forest', 'nature', 'space', 'surreal', 'castle', 'waterfall', 'clouds', 'sky', 'cityscape'}
            subjects = {'women', 'men', 'girl', 'girls', 'portrait', 'face', 'people', 'cars', 'vehicle', 'animals', 'birds', 'cats', 'dogs'}
            if 'AI art'.lower() not in tags or not tags.intersection(scenery) or tags.intersection(subjects): return None
            if item['dimension_x'] < 2560 or item['dimension_y'] < 1440: return None
            data = fetch(item['thumbs']['large'])
            # Validate thumbnails before placing them in the watched folder.
            from PIL import Image, ImageStat
            import io
            image = Image.open(io.BytesIO(data)).convert('RGB')
            sat = ImageStat.Stat(image.convert('HSV')).mean[1]
            if sat < 40: return None
            return item, data
        for _ in range(8):
            if state['exhausted'] or added >= 12: break
            params = dict(q='id:133451', atleast='2560x1440', ratios='16x9', purity='100', sorting='random', page=state['page'])
            if state['seed']: params['seed'] = state['seed']
            page = json.loads(fetch('https://wallhaven.cc/api/v1/search?' + urllib.parse.urlencode(params)))
            state['seed'] = page['meta'].get('seed', state['seed'])
            fresh = [i for i in page['data'] if i['id'] not in state['seen']]
            with concurrent.futures.ThreadPoolExecutor(max_workers=4) as pool:
                futures = [pool.submit(inspect, i) for i in fresh]
                for item, future in zip(fresh, futures):
                    try: result = future.result()
                    except Exception: continue
                    state['seen'].append(item['id'])
                    if not result: continue
                    item, data = result
                    name = 'ddg_' + session + '_' + f"{len(state['seen']):06d}" + '_' + item['id'] + '.jpg'
                    tmp = dest / (name + '.tmp'); tmp.write_bytes(data)
                    with (cache / 'search_map.txt').open('a') as mapping: mapping.write(name + '|' + item['path'] + '\n')
                    os.replace(tmp, dest / name)
                    # Keep attribution and actual source dimensions inspectable.
                    with (cache / 'fantasy_sources.jsonl').open('a') as out: out.write(json.dumps(dict(file=name, url=item['url'], image=item['path'], resolution=item['resolution'], ai_tag=133451)) + '\n')
                    added += 1
            state['page'] += 1
            state['exhausted'] = state['page'] > page['meta']['last_page']
            tmp = statefile.with_suffix('.tmp'); tmp.write_text(json.dumps(state)); os.replace(tmp, statefile)
        print(json.dumps(dict(added=added, exhausted=state['exhausted'], error='')))

if __name__ == '__main__':
    try: main()
    except BlockingIOError: print(json.dumps(dict(added=0, exhausted=False, error='Another wallpaper batch is loading.')))
    except Exception as error: print(json.dumps(dict(added=0, exhausted=False, error='Wallpaper source unavailable; retry scrolling.')))
