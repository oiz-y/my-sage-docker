import os
import json
import sys


args = sys.argv
json_data = {}
json_data['polynomial'] = os.getenv('polynomial')
json_data['time'] = os.getenv('time')
if 'calculation_count' in os.environ:
    json_data['calculation count'] = os.getenv('calculation_count')
with open('/tmp/input.json', 'w') as f:
    json.dump(json_data, f)
