ABS_PATH=$(readlink -f $0)
ABS_DIR=$(dirname $ABS_PATH)

# Create kong namespace
kubectl create namespace kong

helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm repo update

helm install ingress stable/kong --namespace kong -f ${ABS_DIR}/../config.yaml \
  --set ingressController.enabled=true \
  --set env.database=postgres
