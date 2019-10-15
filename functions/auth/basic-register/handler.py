import requests

def handle(req):
    """handle a request to the function
    Args:
        req (str): request body
    """
    # Username and Password extracted from the request
    username=req['username']
    password=req['password']

    # Function response
    resp = {}
    
    # Get Ingress Admin URL which is stored in a secret
    ingress_admin_url_secret = "/var/openfaas/secrets/ingress-admin-url"
    with open(ingress_admin_url_secret) as f:
        ingress_admin_url = f.readline()

    # create consumer
    url = ingress_admin_url + "/consumers/"
    headers = {'content-type': 'application/x-www-form-urlencoded', 'Accept': '*/*'}
    data = {'username': username}
    # verify == False, because self-signed certificates are used
    response = requests.post(url, data=data, headers=headers, verify=False)

    if response.status_code == 201:
        # Create credentials for consumer
        url = ingress_admin_url + "/consumers/" + username + "/basic-auth"
        data = {'username': username, 'password': password}
        # verify == False, because self-signed certificates are used
        response = requests.post(url, dataa=data, headers=headers, verify=False)

        if response.status_code == 201:
            resp.status_code = 201
            resp.message = ""
            return resp

    resp.status_code = 400
    resp.message = "Bad Request: Unable to create user with the provided credentials."
    return resp
