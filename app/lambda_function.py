import json
import os
import boto3

cognito = boto3.client('cognito-idp')

cognito_client_id = os.getenv('COGNITO_CLIENT_ID')
cognito_user_pool_id = os.getenv('COGNITO_USER_POOL_ID')
cognito_admin_username = os.getenv('COGNITO_ADMIN_USERNAME')


def handler(event, context):
    try:
        body = json.loads(event['body'])
        username = body.get('username', cognito_admin_username)
        password = body['password']

        user_exists = check_user_exists(username)

        if user_exists:
            auth_response = initiate_auth(username, password)
        else:
            auth_response = sign_up(username, password)

        if auth_response:
            return {
                'statusCode': 200,
                'body': json.dumps({
                    'message': 'Usuário autenticado com sucesso',
                    'response': auth_response
                })
            }
        else:
            return {
                'statusCode': 400,
                'body': json.dumps({'message': 'Não foi possível autenticar o usuário'})
            }

    except cognito.exceptions.NotAuthorizedException:
        return {
            'statusCode': 401,
            'body': json.dumps({'message': 'Usuário não autorizado'})
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'message': 'Erro desconhecido: ' + str(e)})
        }


def check_user_exists(username):
    try:
        response = cognito.admin_get_user(
            UserPoolId=cognito_user_pool_id,
            Username=username
        )
        return True if response else False
    except cognito.exceptions.UserNotFoundException:
        return False
    except Exception as e:
        print("Erro ao verificar existência do usuário:", e)
        return False


def sign_up(username, password):
    try:
        sign_up_response = cognito.sign_up(
            ClientId=cognito_client_id,
            Username=username,
            Password=password
        )
        return initiate_auth(username, password) if sign_up_response else None
    except Exception as e:
        print("Erro ao registrar usuário:", e)
        return None


def initiate_auth(username, password):
    try:
        return cognito.initiate_auth(
            AuthFlow='USER_PASSWORD_AUTH',
            AuthParameters={
                'USERNAME': username,
                'PASSWORD': password
            },
            ClientId=cognito_client_id
        )
    except Exception as e:
        print("Erro ao autenticar usuário:", e)
        return None