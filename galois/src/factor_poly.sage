import re
import json


def get_poly():
    with open('input.json') as f:
        json_data = json.load(f)
    return json_data

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


def calc_rate(factor_types, conj_type_dict):
    min_average = float('inf')
    target_group = {}
    for group, conj_types in conj_type_dict.items():
        factor_count = {}
        for cycle_type in conj_types:
            if cycle_type not in factor_types:
                break
            factor_count[cycle_type] = 0
        else:
            for factor_type in factor_types:
                if factor_type not in conj_types:
                    break
                factor_count[factor_type] += 1
            else:
                conj_rate = {}
                group_order = sum(conj_types.values())
                for cycle_type, conj_order in conj_types.items():
                    conj_rate[cycle_type] = float(conj_order / group_order)
                factor_rate = {}
                for cycle_type, count in factor_count.items():
                    factor_rate[cycle_type] = float(count / len(factor_types))
                tmp_average = sum(
                    [abs(int(x) - int(y)) for x, y in zip(conj_rate.values(), factor_rate.values())]
                ) / len(factor_rate)
                if tmp_average < min_average:
                    target_group['group'] = {"S": group}
                    target_group['rate'] = {"S": json.dumps(factor_rate)}
    return target_group


def write_json(target_group):
    json_data = get_poly()
    json_data['time'] = {"S": json_data['time']}
    json_data['polynomial'] = {"S": json_data['polynomial']}
    json_data['group'] = target_group['group']
    json_data['rate'] = target_group['rate']
    with open('output.json', 'w') as f:
        json.dump(json_data, f)


if __name__ == '__main__':
    json_data = get_poly()
    conj_types = {
        's3': {
            '1,1,1': 1,
            '1,2': 3,
            '3': 2
        },
        'c3': {
            '1,1,1': 1,
            '3': 2
        }
    }
    factor_types = factor_poly(json_data['polynomial'])
    target_group = calc_rate(factor_types, conj_types)
    write_json(target_group)
