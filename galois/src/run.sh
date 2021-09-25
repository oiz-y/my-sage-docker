echo 'Run!'
python3 create_json.py
echo '/tmp/input.json'
cat /tmp/input.json
sudo sage get_degree.sage
if [ -e /tmp/output.json ]; then
  aws dynamodb put-item \
    --table-name $table_name \
    --item file:///tmp/output.json \
    --region ap-northeast-1 \
    --return-consumed-capacity TOTAL
  exit
fi
ls -l /tmp
aws dynamodb query \
  --table-name $conj_table \
  --key-condition-expression "degree = :v1" \
  --expression-attribute-values file:///tmp/expression_attributes.json \
  --region ap-northeast-1 > /tmp/query_result.json
echo '/tmp/query_result.json'
cat /tmp/query_result.json
echo 'ls -l /tmp'
sudo sage factor_poly.sage
cat /tmp/output.json
aws dynamodb put-item \
  --table-name $table_name \
  --item file:///tmp/output.json \
  --region ap-northeast-1 \
  --return-consumed-capacity TOTAL
