watch "kubectl --namespace=kong get deployments"

ADMIN_IP=$(minikube service -n kong ingress-kong-admin --url | head -1)
PROXY_IP=$(minikube service -n kong ingress-kong-proxy --url | head -1)

echo "Kong-Admin-UI IP: ${ADMIN_IP/http/https}"
echo "Kong-Proxy IP: ${PROXY_IP}"

printf "\nTesting connectivity to Kong..."
curl -i ${PROXY_IP}
printf "\nTest was successful.\n"

