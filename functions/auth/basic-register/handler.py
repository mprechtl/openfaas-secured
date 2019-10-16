import requests
import json 
import urllib3
from jsonschema import validate 
from jsonschema.exceptions import ValidationError


def handle(req):
    """handle a request to the function
    Args:
        req (str): request body
    """
    # Function response
    resp = {}

    # Schema to validate JSON document
    schema = {
        "type" : "object",
        "properties" : {
            "username" : {"type" : "string"},
            "password" : {"type" : "string"},
        },
        "required": ["username", "password"]
    }
    
    # Username and Password extracted from the request
    try:
        body_json = json.loads(req)

        # validate request body against schema
        validate(instance=body_json, schema=schema)

        username=body_json['username']
        password=body_json['password']
    except ValidationError as e:
        resp['status_code'] = 400
        resp['message'] = "Bad Request: You provided a malformed or invalid JSON document."
        return resp    
    except ValueError as e:
        resp['status_code'] = 400
        resp['message'] = "Bad Request: You have to provide a valid JSON document with a username and password."
        return resp  

    # Disable InsecureRequestWarning because of self-signed certificates
    urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

    # Get Ingress Admin URL which is stored in a secret
    ingress_admin_url_secret = "/var/openfaas/secrets/ingress-admin-url"
    with open(ingress_admin_url_secret) as f:
        ingress_admin_url = f.readline()

    # create consumer
    url = ingress_admin_url + "/consumers/"
    headers = {'content-type': 'application/x-www-form-urlencoded', 'Accept': '*/*'}
    data = {'username': username}
    response = requests.post(url, data=data, headers=headers, verify=False)

    if response.status_code == 201:
        # Create credentials for consumer
        url = ingress_admin_url + "/consumers/" + username + "/basic-auth"
        data = {'username': username, 'password': password}
        response = requests.post(url, data=data, headers=headers, verify=False)

        if response.status_code == 201:
            resp['status_code'] = 201
            resp['message'] = ""
            return resp

    resp['status_code'] = response.status_code
    if response.status_code == 409:
        resp['message'] = "Username already taken."
    else:
        resp['message'] = "Unable to create user with the provided credentials."

    return resp
