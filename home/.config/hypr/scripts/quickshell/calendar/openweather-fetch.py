#!/usr/bin/env python3
import json, os, sys, urllib.request, urllib.parse, urllib.error
from pathlib import Path
keyfile=Path.home()/".local/share/openweather/api-key"
key=keyfile.read_text().strip() if keyfile.exists() else os.environ.get("OPENWEATHER_KEY","")
endpoint, city, units=sys.argv[1:]
if endpoint not in ["weather","forecast"]:sys.exit(2)
params=urllib.parse.urlencode({"appid":key,"id":city,"units":units})
url="https://api.openweathermap.org/data/2.5/"+endpoint+"?"+params
try:
    with urllib.request.urlopen(url,timeout=20) as response:sys.stdout.write(response.read().decode())
except urllib.error.HTTPError as e:
    sys.stdout.write(e.read().decode())
except (OSError,TimeoutError):
    sys.stdout.write(json.dumps({"cod":"network-error","message":"Weather request failed"}))
