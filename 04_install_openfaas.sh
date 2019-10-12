kubectl apply -f https://raw.githubusercontent.com/openfaas/faas-netes/master/namespaces.yml

helm repo add openfaas https://openfaas.github.io/faas-netes/

# generate a random password
PASSWORD=$(head -c 12 /dev/urandom | shasum| cut -d' ' -f1)
echo ${PASSWORD} > openfaas_password.txt

# OpenFaaS basic authentication
kubectl -n openfaas create secret generic basic-auth \
  --from-literal=basic-auth-user=admin \
  --from-literal=basic-auth-password=${PASSWORD}

# Install OpenFaaS
helm repo update \
  && helm upgrade openfaas --install openfaas/openfaas \
  --namespace openfaas  \
  --set basic_auth=true \
  --set functionNamespace=openfaas-fn

# To use NodePorts (default) pass no additional flags
# To use a LoadBalancer add --set serviceType=LoadBalancer
# To use an IngressController add --set ingress.enabled=true

OPENFAAS_URL=$(minikube ip):31112
echo ${OPENFAAS_URL} > openfaas_url.txt

echo "OpenFaaS-URL: ${OPENFAAS_URL}"
echo "Password: ${PASSWORD}"

