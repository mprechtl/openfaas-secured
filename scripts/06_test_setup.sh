ABS_PATH=$(readlink -f $0)
ABS_DIR=$(dirname $ABS_PATH)

OPENFAAS_PASSWORD_FILE="${ABS_DIR}/../openfaas_password.txt"
OPENFAAS_URL_FILE="${ABS_DIR}/../openfaas_ui_url.txt"

OPENFAAS_PASSWORD=$(cat ${OPENFAAS_PASSWORD_FILE})
OPENFAAS_URL=$(cat ${OPENFAAS_URL_FILE})

echo -n ${OPENFAAS_PASSWORD} | faas-cli login -g http://$OPENFAAS_URL -u admin --password-stdin

