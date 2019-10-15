blue=$'\e[1;34m'
eblue=$'\e[0m'

ABS_PATH=$(readlink -f $0)
ABS_DIR=$(dirname $ABS_PATH)

OPENFAAS_URL_FILE="${ABS_DIR}/../openfaas_ui_url.txt"
OPENFAAS_URL=$(cat ${OPENFAAS_URL_FILE})

INGRESS_ADMIN_URL_FILE="${ABS_DIR}/../kong_admin_url.txt"
INGRESS_ADMIN_URL=$(cat ${INGRESS_ADMIN_URL_FILE})

INGRESS_PROXY_URL_FILE="${ABS_DIR}/../kong_proxy.txt"
INGRESS_PROXY_URL=$(cat ${INGRESS_PROXY_URL_FILE})

USERNAME="test"
PASSWORD="test"

printf "${blue}Create routing for functions...${eblue}\n\n"

# Create routing for functions
curl -k -X PUT \
    ${INGRESS_ADMIN_URL}/services/function \
    -d "url=http://${OPENFAAS_URL}/function"

printf "\n\n"

curl -k -X POST \
    ${INGRESS_ADMIN_URL}/services/function/routes \
    -d 'name=function' \
    -d 'protocols=http' \
    --data-urlencode 'paths[]=/function'

printf "\n\n${blue}Enable basic authentication for functions...${eblue}\n\n"

# Enable basic authentication
curl -k -X POST ${INGRESS_ADMIN_URL}/plugins \
    -d 'name=basic-auth' \
    -d 'config.hide_credentials=true'

printf "\n\n${blue}Create credentials for user '${USERNAME}' with password '${PASSWORD}'...${eblue}\n\n"

# Create a consumer
curl -k --url ${INGRESS_ADMIN_URL}/consumers/ --data "username=${USERNAME}" -v

# Create credentials for consumer
curl -k -X POST --url ${INGRESS_ADMIN_URL}/consumers/${USERNAME}/basic-auth \
    --data "username=${USERNAME}" \
    --data "password=${PASSWORD}" -v

printf "\n\n${blue}Test 'haveibeenpwned' function again WITHOUT credentials\n\n${eblue}"

# You should get unauthorized
curl --url ${INGRESS_PROXY_URL}/function/haveibeenpwned --data 'test@test.com' -v

printf "\n\n${blue}Test 'haveibeenpwned' function again WITH credentials\n\n${eblue}"

# Test with basic authentication
BASIC_AUTH_CREDENTIALS=$(echo -n ${USERNAME}:${PASSWORD} | base64)
curl --url ${INGRESS_PROXY_URL}/function/haveibeenpwned --data 'test@test.com' -H "Authorization: Basic ${BASIC_AUTH_CREDENTIALS}" -v

printf "\n"

