ABS_PATH=$(readlink -f $0)
ABS_DIR=$(dirname $ABS_PATH)

kubectl apply -f ${ABS_DIR}/letsencrypt-issuer.yaml

# Update OpenFaaS and enable TLS
helm upgrade openfaas \
  --namespace openfaas \
  --reuse-values \
  --values ${ABS_DIR}/tls.yaml \
  openfaas/openfaas
