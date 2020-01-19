
blue=$'\e[1;34m'
eblue=$'\e[0m'

ABS_PATH=$(readlink -f $0)
ABS_DIR=$(dirname $ABS_PATH)

INGRESS_PROXY_URL_FILE="${ABS_DIR}/../../../../kong_proxy.txt"
INGRESS_PROXY_URL=$(cat ${INGRESS_PROXY_URL_FILE})

FUNCTION_USERNAME_FILE="${ABS_DIR}/../../../function_username.txt"
FUNCTION_PASSWORD_FILE="${ABS_DIR}/../../../function_password.txt"
USERNAME=$(cat ${FUNCTION_USERNAME_FILE})
PASSWORD=$(cat ${FUNCTION_PASSWORD_FILE})

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
