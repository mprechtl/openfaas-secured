ABS_PATH=$(readlink -f $0)
ABS_DIR=$(dirname $ABS_PATH)

OPENFAAS_URL_FILE="${ABS_DIR}/../openfaas_ui_url.txt"
OPENFAAS_URL=$(cat ${OPENFAAS_URL_FILE})

cd ${ABS_DIR}
faas-cli build -f stack.yml
faas-cli deploy stack.yml --gateway ${OPENFAAS_URL}
cd -
