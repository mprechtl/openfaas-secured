# Create kong namespace
kubectl create namespace nginx

helm install ingress stable/nginx-ingress --namespace nginx --set rbac.create=true,controller.hostNetwork=true,controller.daemonset.useHostPort=true,dnsPolicy=ClusterFirstWithHostNet,controller.kind=DaemonSet

