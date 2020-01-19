ABS_PATH=$(readlink -f $0)
ABS_DIR=$(dirname $ABS_PATH)

# Create kong namespace
kubectl create namespace kong

helm repo add kong https://charts.konghq.com
helm repo update

helm install ingress kong/kong --namespace kong -f ${ABS_DIR}/../config.yaml \
  --set ingressController.enabled=true \
  --set env.database=postgres \
  --set admin.enabled=true
