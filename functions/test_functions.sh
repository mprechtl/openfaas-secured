
blue=$'\e[1;34m'
eblue=$'\e[0m'

ABS_PATH=$(readlink -f $0)
ABS_DIR=$(dirname $ABS_PATH)

OPENFAAS_URL_FILE="${ABS_DIR}/../openfaas_ui_url.txt"
OPENFAAS_URL=$(cat ${OPENFAAS_URL_FILE})

printf "${blue}Test 'haveibeenpwned' function\n\n${eblue}"
curl -X POST --url ${OPENFAAS_URL}/function/unprotected-haveibeenpwned --data 'test@test.com'
