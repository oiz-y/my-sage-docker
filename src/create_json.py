import json
import sys


args = sys.argv
json_data = {}
json_data[args[1]] = args[2]
with open('input.json', 'w') as f:
    json.dump(json_data, f)

json_data = {}
json_data[args[3]] = {"S": args[4]}
json_data['status'] = {"S": "done"}
with open('item.json', 'w') as f:
    json.dump(json_data, f)
