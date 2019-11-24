blue=$'\e[1;34m'
eblue=$'\e[0m'

printf "${blue}Wait until Nginx ingress controller is up... (Then leave with CTRL + C)${eblue}\n\n"

kubectl --namespace nginx get deployments --watch

