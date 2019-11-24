blue=$'\e[1;34m'
eblue=$'\e[0m'

printf "${blue}\nWait until Kong ingress controller is up... (Then leave with CTRL + C)${eblue}\n\n"
kubectl --namespace=kong get deployments -w

printf "${blue}\n\nGet IP addresses of Kong interfaces...${eblue}\n\n"
sleep 1

ADMIN_IP=$(minikube service -n kong ingress-kong-admin --url | head -1)
PROXY_IP=$(minikube service -n kong ingress-kong-proxy --url | head -1)

echo "Kong-Admin-UI IP: ${ADMIN_IP/http/https}"
echo "Kong-Proxy IP: ${PROXY_IP}"

echo ${ADMIN_IP/http/https} > kong_admin_url.txt
echo ${PROXY_IP} > kong_proxy.txt

printf "\nTesting connectivity to Kong..."
curl -i ${PROXY_IP}
printf "\nTest was successful.\n"
