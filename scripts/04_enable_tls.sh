ABS_PATH=$(readlink -f $0)
ABS_DIR=$(dirname $ABS_PATH)

# TLS certificate and key
KEY_FILE=tls.key
CERT_FILE=tls.crt

# Host
HOST=*.secure-faas.com

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ${ABS_DIR}/../${KEY_FILE} -out ${ABS_DIR}/../${CERT_FILE} -subj "/CN=${HOST}/O=${HOST}"

# Create TLS secret within the cluster
kubectl -n openfaas create secret tls tls-secret --key ${ABS_DIR}/../${KEY_FILE} --cert ${ABS_DIR}/../${CERT_FILE}

kubectl apply -f ${ABS_DIR}/../tls/tls.yaml
