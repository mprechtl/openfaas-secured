blue=$'\e[1;34m'
eblue=$'\e[0m'

ABS_PATH=$(readlink -f $0)
ABS_DIR=$(dirname $ABS_PATH)

OPENFAAS_URL_FILE="${ABS_DIR}/../../../../openfaas_ui_url.txt"
OPENFAAS_URL=$(cat ${OPENFAAS_URL_FILE})

INGRESS_ADMIN_URL_FILE="${ABS_DIR}/../../../../kong_admin_url.txt"
INGRESS_ADMIN_URL=$(cat ${INGRESS_ADMIN_URL_FILE})

INGRESS_PROXY_URL_FILE="${ABS_DIR}/../../../../kong_proxy.txt"
INGRESS_PROXY_URL=$(cat ${INGRESS_PROXY_URL_FILE})


###########################################################################################
#                       Enable Basic Authentication
###########################################################################################

printf "${blue}Enable basic authentication for functions...${eblue}\n\n"

# Enable basic authentication
curl -k -X POST ${INGRESS_ADMIN_URL}/routes/protected-functions/plugins \
    -d 'name=basic-auth' \
    -d 'config.hide_credentials=true'


###########################################################################################
#                       Create Users (Basic Auth)
###########################################################################################

USERNAME="test"
echo ${USERNAME} > ${ABS_DIR}/../../../function_username.txt

PASSWORD=$(head -c 12 /dev/urandom | shasum| cut -d' ' -f1)
echo ${PASSWORD} > ${ABS_DIR}/../../../function_password.txt

printf "\n\n${blue}Create credentials for user '${USERNAME}' with password '${PASSWORD}'...${eblue}\n\n"

curl --url ${INGRESS_PROXY_URL}/function/basic-register --data "{\"username\": \"${USERNAME}\", \"password\": \"${PASSWORD}\"}" -v
