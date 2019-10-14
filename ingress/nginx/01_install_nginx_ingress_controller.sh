helm install stable/nginx-ingress --name nginxingress --set rbac.create=true,controller.hostNetwork=true,controller.daemonset.useHostPort=true,dnsPolicy=ClusterFirstWithHostNet,controller.kind=DaemonSet

