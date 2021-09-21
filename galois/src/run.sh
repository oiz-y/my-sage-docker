echo 'Run!'
python3 create_json.py polynomial "$polynomial" time "$time"
cat input.json
sudo sage factor_poly.sage
cat output.json
aws dynamodb put-item --table-name $table_name --item file://output.json --region ap-northeast-1 --return-consumed-capacity TOTAL
