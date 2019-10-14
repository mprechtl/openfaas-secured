blue=$'\e[1;34m'
eblue=$'\e[0m'

printf "${blue}Wait until OpenFaaS Gateway is up... (Then leave with CTRL + C)${eblue}\n\n"
kubectl --namespace=openfaas get deployments -l 'release=openfaas, app=openfaas' -w

