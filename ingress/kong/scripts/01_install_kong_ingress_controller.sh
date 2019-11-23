helm repo add default https://hub.helm.sh
helm repo update
helm install stable/kong -n ingress --namespace kong --set ingressController.enabled=true

