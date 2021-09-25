import sys
import json

with open('/tmp/input.json') as f:
    json_data = json_data = json.load(f)
poly = json_data['polynomial']
R.<x> = PolynomialRing(QQ)
try:
    poly = R(poly)
except Exception as e:
    print('Exception:', e)
    with open('/tmp/output.json', 'w') as f:
        json_data['time'] = {"S": json_data['time']}
        json_data['polynomial'] = {"S": json_data['polynomial']}
        json_data['group'] = {"S": 'Malformed expression polynomial'}
        json_data['rate'] = {"S": 'Malformed expression polynomial'}
        json_data['status'] = {"S": "done"}
        json.dump(json_data, f)
    sys.exit()

degree = poly.degree()
json_data = {}
json_data[":v1"] = {"N": str(degree)}
with open('/tmp/expression_attributes.json', 'w') as f:
    json.dump(json_data, f)
