import re
import sys
import json
import boto3
from boto3.dynamodb.conditions import Key


def get_poly():
    with open('/tmp/input.json') as f:
        json_data = json.load(f)
    return json_data


def check_irreducible(poly):
    R.<x> = PolynomialRing(QQ)
    try:
        f = R(poly)
    except Exception as e:
        print('Exception:', e)
    target_group = {}
    if not f.is_irreducible():
        target_group['group'] = {"S": 'not an irreducible polynomial'}
        target_group['rate'] = {"S": 'not an irreducible polynomial'}
    return target_group


def get_poly_degree(poly):
    R.<x> = PolynomialRing(QQ)
    f = R(poly)
    # Type of f.degree() is <class 'sage.rings.integer.Integer'>.
    return int(f.degree())


def factor_poly(poly):
    factor_types = []
    for p in range(1000):
        if not is_prime(p):
            continue
        R.<x> = PolynomialRing(GF(p))
        factor_dict = get_factor_data(list(R(poly).factor()))
        if factor_dict:
            factor_type = ','.join([str(t[0]) for t in list(factor_dict.values())])
            factor_types.append(factor_type)
    return factor_types


def get_factor_data(factors):
    factor_dict = {}
    for f in factors:
        pol_deg = re.sub(r'[^\d]', '', str(f).split(' ')[0])
        if f[1] > 1:
            return None
        if pol_deg == '':
            factor_dict[str(f[0])] = (1, f[1])
        else:
            factor_dict[str(f[0])] = (int(pol_deg), f[1])
    return factor_dict


def query_groups(degree, dynamodb=None):
    # Not working due to the following error:
    # botocore.exceptions.NoCredentialsError: Unable to locate credentials
    if not dynamodb:
        dynamodb = boto3.resource('dynamodb', region_name='ap-northeast-1')

    table = dynamodb.Table('sage-conjugacy-rate')
    response = table.query(
        KeyConditionExpression=Key('degree').eq(degree)
    )
    return response['Items']


def get_query_result():
    with open('/tmp/query_result.json') as f:
        json_data = json.load(f)
    if json_data['Count'] == 0:
        with open('/tmp/input.json') as f:
            json_data = json.load(f)
            json_data['time'] = {"S": json_data['time']}
            json_data['polynomial'] = {"S": json_data['polynomial']}
            json_data['group'] = {"S": 'not supported degree'}
            json_data['rate'] = {"S": 'not supported degree'}
            json_data['status'] = {"S": "done"}
            if 'calculation count' in json_data:
                json_data['calculation count'] = {"N": json_data['calculation count']}
        with open('/tmp/output.json', 'w') as f:
            json.dump(json_data, f)
            sys.exit()
    return json_data['Items']


def convert_format(groups):
    conj_types = {}
    for group_dict in groups:
        conj_types[group_dict['group_name']['S']] = json.loads(group_dict['conjugacy_rate']['S'])
    return conj_types


def calc_rate(factor_types, conj_type_dict):
    min_average = float('inf')
    target_group = {}
    for group, conj_types in conj_type_dict.items():
        factor_count = {}
        not_in_count = 0
        for cycle_type in conj_types:
            if (cycle_type not in factor_types and
                cycle_type.split(',') != ['1'] * len(cycle_type.split(','))):
                not_in_count += 1
                continue
            factor_count[cycle_type] = factor_types.count(cycle_type)
        if sum(factor_count.values()) < not_in_count:
            continue
        for factor_type in factor_types:
            if factor_type not in conj_types:
                break
        else:
            factor_rate = {}
            for cycle_type, count in factor_count.items():
                factor_rate[cycle_type] = float(count / len(factor_types))
            tmp_average = sum(
                [abs(float(factor_rate[cycle_type]) - float(conj_types[cycle_type]))
                    for cycle_type in factor_types]
            ) / len(factor_rate)
            if tmp_average < min_average:
                target_group['group'] = {"S": group}
                target_group['rate'] = {"S": json.dumps(factor_rate)}
                min_average = tmp_average
    return target_group


def write_json(target_group):
    json_data = get_poly()
    json_data['time'] = {"S": json_data['time']}
    json_data['polynomial'] = {"S": json_data['polynomial']}
    json_data['group'] = target_group['group']
    json_data['rate'] = target_group['rate']
    json_data['status'] = {"S": "done"}
    if 'calculation count' in json_data:
        json_data['calculation count'] = {"N": json_data['calculation count']}
    with open('/tmp/output.json', 'w') as f:
        json.dump(json_data, f)


if __name__ == '__main__':
    json_data = get_poly()
    target_group = check_irreducible(json_data['polynomial'])
    if target_group:
        write_json(target_group)
    else:
        degree = get_poly_degree(json_data['polynomial'])
        # The following method will cause NoCredentialsError.
        # groups = query_groups(degree)
        groups = get_query_result()
        conj_types = convert_format(groups)
        factor_types = factor_poly(json_data['polynomial'])
        target_group = calc_rate(factor_types, conj_types)
        write_json(target_group)
