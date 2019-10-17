
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
   > http://oidc.secure-faas.com/validate, http://oidc.secure-faas.com/callback
 - When `Auth0` is used, you should choose `Regular Web Application` as application type 

 - Edit `/oidc-plugin/oidc-plugin-dep.yaml` to set your OpenID Connect configuration. All endpoints can be found by showing the advanced settings and choosing `Endpoints`. The `client-id` and `client-secret` can be found in the application settings.

 - Run the deployment script:

    > $ ./deploy.sh

 - Use the OpenFaaS Gateway: http://gw.secure-faas.com
