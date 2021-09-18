echo 'Run!'
python3 create_json.py 'num' $num 'time' $time
sage -c "load('sample.sage')"
aws dynamodb put-item \
  --table-name sage-table \
  --item file://output.json \
  --return-consumed-capacity TOTAL \
  --region ap-northeast-1
