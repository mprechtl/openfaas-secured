OPENFAAS_PASSWORD_FILE="./openfaas_password.txt"
OPENFAAS_URL_FILE="./openfaas_url.txt"

OPENFAAS_PASSWORD=$(cat ${OPENFAAS_PASSWORD_FILE})
OPENFAAS_URL=$(cat ${OPENFAAS_URL_FILE})

echo "${OPENFAAS_PASSWORD}"
echo "${OPENFAAS_URL}"

echo -n ${OPENFAAS_PASSWORD} | faas-cli login -g http://$OPENFAAS_URL -u admin --password-stdin

