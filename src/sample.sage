import datetime
import json


print('Hello!')
with open('input.json') as f:
    json_data = json.load(f)
print(json_data)
num = int(json_data['num'])
file = open('/src/output.txt', 'w')
if is_prime(num):
    file.write(f'{num} is prime.\n')
else:
    file.write(f'{num} is not prime.\n')
file.write(str(datetime.datetime.now()) + '\n')
file.close()
