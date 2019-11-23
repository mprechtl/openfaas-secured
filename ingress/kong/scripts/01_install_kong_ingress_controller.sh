ABS_PATH=$(readlink -f $0)
ABS_DIR=$(dirname $ABS_PATH)

helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm repo update

kubectl create namespace kong
helm install ingress stable/kong --namespace kong -f ${ABS_DIR}/../config.yaml --set ingressController.enabled=true
