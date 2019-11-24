ABS_PATH=$(readlink -f $0)
ABS_DIR=$(dirname $ABS_PATH)

# Create kong namespace
kubectl create namespace kong

# generate a random password for database access
PASSWORD=$(head -c 12 /dev/urandom | shasum| cut -d' ' -f1)

# Create secret
kubectl -n kong create secret generic kong \
  --from-literal=postgres=${PASSWORD}

helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm repo update

helm install ingress stable/kong --namespace kong -f ${ABS_DIR}/../config.yaml --set ingressController.enabled=true --set env.database=postgres
