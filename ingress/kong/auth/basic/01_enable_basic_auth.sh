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


###########################################################################################
#                       Test Basic Authentication
###########################################################################################

printf "\n\n${blue}Test 'haveibeenpwned' function again WITHOUT credentials\n\n${eblue}"

# You should get unauthorized
curl --url ${INGRESS_PROXY_URL}/function/protected-haveibeenpwned --data 'test@test.com' -v

printf "\n\n${blue}Test 'haveibeenpwned' function again WITH correct credentials\n\n${eblue}"

# Test with basic authentication
BASIC_AUTH_CREDENTIALS=$(echo -n ${USERNAME}:${PASSWORD} | base64)
curl --url ${INGRESS_PROXY_URL}/function/protected-haveibeenpwned --data 'test@test.com' -H "Authorization: Basic ${BASIC_AUTH_CREDENTIALS}" -v

printf "\n\n${blue}Test 'haveibeenpwned' function again WITH wrong credentials\n\n${eblue}"

BASIC_AUTH_CREDENTIALS_WRONG=$(echo -n wrong:wrong | base64)
curl --url ${INGRESS_PROXY_URL}/function/protected-haveibeenpwned --data 'test@test.com' -H "Authorization: Basic ${BASIC_AUTH_CREDENTIALS_WRONG}" -v

# Test unprotected function
printf "\n\n${blue}Test unprotected 'haveibeenpwned' function\n\n${eblue}"

curl --url ${INGRESS_PROXY_URL}/function/unprotected-haveibeenpwned --data 'test@test.com' -v

printf "\n"
