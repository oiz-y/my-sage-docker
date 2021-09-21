import json


with open('input.json') as f:
    json_data = json.load(f)

num = int(json_data['num'])
json_data['num'] = {"S": json_data['num']}
json_data['time'] = {"S": json_data['time']}
json_data['status'] = {"S": "done"}

if is_prime(num):
    json_data['result'] = {"S": "prime"}
else:
    json_data['result'] = {"S": "not prime"}

with open('output.json', 'w') as f:
    json.dump(json_data, f)
