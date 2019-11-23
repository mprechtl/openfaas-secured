helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm repo update

kubectl create namespace kong
helm install ingress stable/kong --namespace kong --set ingressController.enabled=true

