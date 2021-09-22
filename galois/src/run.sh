echo 'Run!'
python3 create_json.py
sudo sage get_degree.sage
aws dynamodb query \
  --table-name $conj_table \
  --key-condition-expression "degree = :v1" \
  --expression-attribute-values file://expression_attributes.json \
  --region ap-northeast-1 > query_result.json
sudo sage factor_poly.sage
cat output.json
aws dynamodb put-item \
  --table-name $table_name \
  --item file://output.json \
  --region ap-northeast-1 \
  --return-consumed-capacity TOTAL
