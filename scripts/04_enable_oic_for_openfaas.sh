
ABS_PATH=$(readlink -f $0)
ABS_DIR=$(dirname $ABS_PATH)

blue=$'\e[1;34m'
eblue=$'\e[0m'

###########################################################################################
#                       Enable OIC for OpenFaaS Gateway
###########################################################################################

kubectl apply -f ${ABS_DIR}/../oidc-plugin/yaml/

#OIDC_PLUGIN_URL="$(kubectl get pods -n openfaas --output=wide | grep oidc-plugin | awk '{print $6}'):8080"

kubectl patch -n openfaas deploy/gateway --patch '
{
  "spec": {
    "template": {
      "spec": {
        "containers": [
          {
            "env": [
              {
                "name": "auth_proxy_url",
                "value": "http://oidc.secure-faas.com/validate"
              }
            ],
            "name": "gateway"
          }
        ]
      }
    }
  }
}
'

printf "${blue}\nSudo is required to modify the hosts file.${eblue}\n\n"

sudo sed -i '/oidc.secure-faas.com/d' /etc/hosts
sudo sed -i '/gw.secure-faas.com/d' /etc/hosts

# Redirect to entrypoint of minikube
echo "$(minikube ip) oidc.secure-faas.com" | sudo tee -a /etc/hosts
echo "$(minikube ip) gw.secure-faas.com" | sudo tee -a /etc/hosts

# Enable ingress for minikube
minikube addons enable ingress
