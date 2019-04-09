import json
import base64
import sys

import boto3
from botocore.exceptions import ClientError


def get_secret(secret_name):

    REGION_NAME = 'us-east-1'

    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=REGION_NAME
    )

    try:
        get_secret_value_response = client.get_secret_value(
            SecretId=secret_name
        )
    except ClientError as e:
        if e.response['Error']['Code'] == 'DecryptionFailureException':
            raise e
        elif e.response['Error']['Code'] == 'InternalServiceErrorException':
            raise e
        elif e.response['Error']['Code'] == 'InvalidParameterException':
            raise e
        elif e.response['Error']['Code'] == 'InvalidRequestException':
            raise e
        elif e.response['Error']['Code'] == 'ResourceNotFoundException':
            raise e
    else:
        if 'SecretString' in get_secret_value_response:
            secret = get_secret_value_response['SecretString']
        else:
            secret = base64.b64decode(get_secret_value_response['SecretBinary'])

    secret = json.loads(secret)
    return secret 

def build_bash_cmd(secret):
    bash_cmd = 'export AIRFLOW__CORE__FERNET_KEY={}'.format(secret['fernet_key'])
    return bash_cmd

def main():
    secret = get_secret('airflow-fernet')
    bash_cmd = build_bash_cmd(secret)
    sys.stdout.write(bash_cmd)

if __name__ == '__main__':
    main()