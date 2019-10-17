green=$'\e[1;32m'
egreen=$'\e[0m'

ABS_PATH=$(readlink -f $0)
ABS_DIR=$(dirname $ABS_PATH)

OPENFAAS_URL_FILE="${ABS_DIR}/../openfaas_ui_url.txt"
OPENFAAS_URL=$(cat ${OPENFAAS_URL_FILE})

# Create secret to access ingress admin interface
INGRESS_ADMIN_URL_FILE="${ABS_DIR}/../kong_admin_url.txt"
INGRESS_ADMIN_URL=$(cat ${INGRESS_ADMIN_URL_FILE})

printf "${green}\n\n====================================================================================================\n${egreen}"
printf "${green}\t\t\t\tDeploy sample functions\n${egreen}"
printf "${green}====================================================================================================\n\n${egreen}"

# Create secret for OpenFaaS function namespace
kubectl create secret generic ingress-admin-url \
  --from-literal ingress-admin-url="${INGRESS_ADMIN_URL}" \
  --namespace openfaas-fn

# Build OpenFaaS functions and deploy them
cd ${ABS_DIR}
faas-cli build -f stack.yml
faas push --filter "basic-register"
faas-cli deploy stack.yml --gateway ${OPENFAAS_URL} --token="${TOKEN}"
cd -
