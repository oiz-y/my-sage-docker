import os
import json
import sys


args = sys.argv
json_data = {}
json_data['polynomial'] = os.getenv('polynomial')
json_data['time'] = os.getenv('time')
with open('input.json', 'w') as f:
    json.dump(json_data, f)
