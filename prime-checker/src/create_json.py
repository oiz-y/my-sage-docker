import json
import sys


args = sys.argv
json_data = {}
json_data[args[1]] = args[2]
json_data[args[3]] = args[4]
with open('input.json', 'w') as f:
    json.dump(json_data, f)
