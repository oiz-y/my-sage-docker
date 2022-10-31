import sys
import logging

logging.basicConfig(level=logging.DEBUG)


def _check_irreducible(poly):
    R.<x> = PolynomialRing(QQ)
    try:
        f = R(poly)
    except Exception as e:
        logging.error('Exception:', e)
        raise Exception(poly)
    return f.is_irreducible()


def _get_poly_degree(poly):
    R.<x> = PolynomialRing(QQ)
    f = R(poly)
    return int(f.degree())


def _check_multiple_root(factor_info):
    for _, power in factor_info:
        if power > 1:
            return True
    return False


def factor_poly(poly):
    factor_types = []
    for p in range(100):
        if not is_prime(p):
            continue
        R.<x> = PolynomialRing(GF(p))
        factor_info = list(R(poly).factor())
        if _check_multiple_root(factor_info):
            continue
        factor_type = ','.join([str(_get_poly_degree(factor)) for factor, _ in factor_info])
        factor_types.append(factor_type)
    return factor_types


def main(event, context):
    polynomial = event['inputPolynomial']
    logging.debug(polynomial)
    is_irreducible = _check_irreducible(polynomial)
    factor_dict = factor_poly(polynomial)
    logging.info(factor_dict)


if __name__ == '__main__':
    args = sys.argv
    event = {
        'inputPolynomial': args[1],
        'primeRange': args[2]
    }
    logging.debug(event)
    main(event, '')
