set -x
event=`curl "http://${AWS_LAMBDA_RUNTIME_API}/2018-06-01/runtime/invocation/next"`
polynomial=`echo ${event} | jq '.inputPolynomial' | sed -e 's/^"//g' -e 's/"$//g'`
prime_range=`echo ${event} | jq '.primeRange' | sed -e 's/^"//g' -e 's/"$//g'`
analysis_id=`echo ${event} | jq '.analysisId' | sed -e 's/^"//g' -e 's/"$//g'`
sage --nodotsage polynomial_factorization.sage ${polynomial} ${prime_range} ${analysis_id}
