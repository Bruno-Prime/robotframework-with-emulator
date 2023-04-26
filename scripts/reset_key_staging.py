import json
import sys

import requests


def make_session(url, login, password) -> str:

    response = requests.post(url=f'{url}/api/v1/users/sign_in', json={
        'user': {
            'email': login,
            'password': password,
            'identify_login': True
        }
    })

    if response.status_code == 200:
        response = response.json()

        return response['session']['authentication_token']
    else:
        message = ''
        try:
            response = response.json()
            message = response['errors']
        except:
            message = response.text

        raise Exception(f'Ouve um erro na autenticação\n\n{message}')

def clear_key(url, key, token, id):

    response = requests.put(url=f'{url}/api/v1/registered_devices/{id}', json={
        "is_readonly": False,
	    "data_custom_form": "",
	    "id": id,
	    "auth_key": key,
	    "device_id": "",
	    "sec_device_id": "",
	    "device_name": "",
	    "auth_datetime": "2023-04-26T10:24:36-0300",
	    "last_login": "2023-04-26T10:24:45-0300",
	    "last_user": "QUALIDADE 001",
	    "is_active": True,
	    "record_ident": "automation"
    }, headers={
        'Content-Type': 'application/json',
        'authorization': f'Token token={token}'
    })

    if response.status_code == 200:
        print('Reset realizado com sucesso')
    else:
        raise Exception(response.text)

if __name__ == '__main__':
    if len(sys.argv) < 5:
        print('Uso: python reset_key.py <URL_AMBIENTE> <login> <senha> <chave> <id>')
    else:

        url = sys.argv[1]
        login = sys.argv[2]
        password = sys.argv[3]
        key = sys.argv[4]
        id = sys.argv[5]

        token = make_session(url, login, password)
        if token is not None:
            clear_key(url, key, token, id)
        pass