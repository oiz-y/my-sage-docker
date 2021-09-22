import json

with open('input.json') as f:
    json_data = json_data = json.load(f)
poly = json_data['polynomial']
R.<x> = PolynomialRing(QQ)
poly = R(poly)
degree = poly.degree()
json_data = {}
json_data[":v1"] = {"N": str(degree)}
with open('expression_attributes.json', 'w') as f:
    json.dump(json_data, f)
