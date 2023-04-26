import json
import sys

import requests
from requests_toolbelt.multipart.encoder import MultipartEncoder


def upload_apk_to_perfecto_cloud(cloud_name, token, apk_path, output):
    url = f"https://{cloud_name}.app.perfectomobile.com/repository/api/v1/artifacts"
    mp_encoder = MultipartEncoder(
        fields={
            "inputStream": open(apk_path, "rb"),
            'requestPart': json.dumps({
                "artifactLocator": f"PRIVATE:{output}",
                "mimeType": "multipart/form-data",
                "override": "true",
                "artifactType": "ANDROID"
            }),
        }
    )
    headers = {
        "Content-Type": mp_encoder.content_type,
        "Perfecto-Authorization": token
    }

    response = requests.post(url, headers=headers, data=mp_encoder)

    if response.status_code == 200:
        print("Arquivo APK enviado com sucesso para a Perfecto Cloud!")
    else:
        print(f"Ocorreu um erro ao enviar o arquivo APK: {response.text}")

if __name__ == '__main__':
    if len(sys.argv) < 4:
        print("Uso: python upload_apk.py <cloud_name> <token> <apk_path>")
    else:
        cloud_name = sys.argv[1]
        token = sys.argv[2]
        apk_path = sys.argv[3]
        output_name = sys.argv[4]
        upload_apk_to_perfecto_cloud(cloud_name, token, apk_path, output_name)