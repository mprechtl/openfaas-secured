blue=$'\e[1;34m'
eblue=$'\e[0m'

ABS_PATH=$(readlink -f $0)
ABS_DIR=$(dirname $ABS_PATH)

OPENFAAS_URL_FILE="${ABS_DIR}/../../../openfaas_ui_url.txt"
OPENFAAS_URL=$(cat ${OPENFAAS_URL_FILE})

INGRESS_ADMIN_URL_FILE="${ABS_DIR}/../../../kong_admin_url.txt"
INGRESS_ADMIN_URL=$(cat ${INGRESS_ADMIN_URL_FILE})


###########################################################################################
#                       Routing
###########################################################################################

printf "\n${blue}Add OpenFaaS as service to Kong...${eblue}\n\n"

curl -k -X PUT \
    ${INGRESS_ADMIN_URL}/services/function \
    -d "url=http://${OPENFAAS_URL}"

# Create routing for protected functions
printf "\n\n${blue}Create routing to protected functions...${eblue}\n\n"

curl -k -X POST \
    ${INGRESS_ADMIN_URL}/services/function/routes \
    -d 'name=protected-functions' \
    -d 'strip_path=false' \
    --data-urlencode 'paths[]=/function/protected-haveibeenpwned'

# Create routing for unprotected functions
printf "\n\n${blue}Create routing to unprotected functions...${eblue}\n\n"

curl -k -X POST \
    ${INGRESS_ADMIN_URL}/services/function/routes \
    -d 'name=unprotected-functions' \
    -d 'strip_path=false' \
    --data-urlencode 'paths[]=/function/basic-register' \
    --data-urlencode 'paths[]=/function/unprotected-haveibeenpwned'

printf "\n"


