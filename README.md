
# Getting Started

## Prerequisites

 - Minikube
 - FaaS-CLI
 - Kubectl
 - Helm

## Installing and Deployment

 - Choose an Identity Provider (such as [Auth0](https://auth0.com/))
 - Sign up and add the application `OpenFaaS Gateway`
 - Setup two callback URLs for your application:
   > http://oidc.secure-faas.com/validate, http://oidc.secure-faas.com/callback, http://127.0.0.1:31111/oauth/callback
 - When `Auth0` is used, you should choose `Regular Web Application` as application type 

 - Edit `/oidc-plugin/oidc-plugin-dep.yaml` to set your OpenID Connect configuration. All endpoints can be found by showing the advanced settings and choosing `Endpoints`. The `client-id` and `client-secret` can be found in the application settings.

 - Run the deployment script:

    > $ ./deploy.sh

 - Use the OpenFaaS Gateway: http://gw.secure-faas.com

 - Deploy the provided functions by adding the `authorization URL`, `audience URL` and `client-id` to the `faas_cli_login.sh` script and then executing it:
   > $ ./functions/faas_cli_login.sh

   After exporting the provided token, you should run:
   > $ ./functions/deploy_functions.sh

 - Now, you are able to enable basic-authentication for the functions by executing:
   > $ ./ingress/kong/auth/enable_basic_auth.sh
