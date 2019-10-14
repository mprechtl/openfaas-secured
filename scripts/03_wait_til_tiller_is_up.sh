blue=$'\e[1;34m'
eblue=$'\e[0m'

printf "${blue}Wait until Tiller is up... (Then leave with CTRL + C)${eblue}\n\n"
kubectl -n kube-system get po -w

