echo 'Run!'
python3 create_json.py 'num' $num 'time' $time
cat input.json
cat item.json
sage -c "load('sample.sage')"
cat output.txt
aws dynamodb put-item \
  --table-name sage-table \
  --item file://item.json \
  --return-consumed-capacity TOTAL \
  --region ap-northeast-1
