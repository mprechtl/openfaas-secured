
# A secured OpenFaaS environment

This repository should provide guidelines in which way an OpenFaaS environment can be secured by relying on techniques and technologies such as OpenID Connect and Kong as ingress controller.

# Getting Started

## Prerequisites

 - Minikube (>= 1.4.0)
 - FaaS-CLI (>= 0.9.3)
 - Kubectl (>= 1.16.1)
 - Helm (>= 3.0.0)
 
## Installing

 - Choose an Identity Provider (such as [Auth0](https://auth0.com/))
 - Sign up and add the application `OpenFaaS Gateway`
 - Setup two callback URLs for your application:
   > http://oidc.secure-faas.com/validate, http://oidc.secure-faas.com/callback, http://127.0.0.1:31111/oauth/callback
 - When `Auth0` is used, you should choose `Regular Web Application` as application type 

 - Edit `/oidc-plugin/oidc-plugin-dep.yaml` to set your OpenID Connect configuration. All endpoints can be found by showing the advanced settings and choosing `Endpoints`. The `client-id` and `client-secret` can be found in the application settings.

 - Run the deployment script:

    > $ ./deploy.sh

 - Use the OpenFaaS Gateway: http://gw.secure-faas.com

## Deployment of Functions

 - Deploy the provided functions by adding the `authorization URL`, `audience URL` and `client-id` to the `faas_cli_login.sh` script and then executing it:
   > $ ./functions/faas_cli_login.sh

   After exporting the provided token, you should run:
   > $ ./functions/deploy_functions.sh

## Enable routing and basic authentication

 - Enable routing to the functions:
   > $ ./ingress/kong/auth/enable_routing.sh

 - Now, you are able to enable basic-authentication for the functions by executing:
   > $ ./ingress/kong/auth/enable_basic_auth.sh

 - Test your setup:
   > $ curl --url ${INGRESS_PROXY_URL}/function/protected-haveibeenpwned --data 'test@test.com' -H "Authorization: Basic ${BASE64_CREDENTIALS}" -v
   
   For more information see the script `ingress/kong/auth/enable_basic_auth.sh`

