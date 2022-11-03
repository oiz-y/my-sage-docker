import boto3
from boto3.dynamodb.conditions import Key


dynamodb = boto3.resource('dynamodb', region_name='ap-northeast-1')


def get_group_data(degree):
    table = dynamodb.Table('sage-conjugacy-rate')
    response = table.query(
        KeyConditionExpression=Key('degree').eq(degree)
    )
    return response['Items']
