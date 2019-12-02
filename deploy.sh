
green=$'\e[1;32m'
egreen=$'\e[0m'

printf "${green}====================================================================================================\n${egreen}"
printf "${green}\t\t\t\tStart Minikube\n${egreen}"
printf "${green}====================================================================================================\n\n${egreen}"

./scripts/01_start_minikube.sh

printf "${green}\n\n====================================================================================================\n${egreen}"
printf "${green}\t\t\t\tInstall OpenFaaS\n${egreen}"
printf "${green}====================================================================================================\n\n${egreen}"

./scripts/02_install_openfaas.sh

printf "${green}\n\n====================================================================================================\n${egreen}"
printf "${green}\t\t\t\tWait til OpenFaaS is up...\n${egreen}"
printf "${green}====================================================================================================\n\n${egreen}"

./scripts/03_wait_til_openfaas_is_up.sh

printf "${green}\n\n====================================================================================================\n${egreen}"
printf "${green}\t\t\t\tInstall Kong\n${egreen}"
printf "${green}====================================================================================================\n\n${egreen}"

./ingress/kong/scripts/01_install_kong_ingress_controller.sh
./ingress/kong/scripts/02_wait_til_kong_is_up.sh

printf "${green}\n\n====================================================================================================\n${egreen}"
printf "${green}\t\t\tEnable TLS\n${egreen}"
printf "${green}====================================================================================================\n\n${egreen}"

./ingress/nginx/scripts/01_install_nginx_ingress_controller.sh
./ingress/nginx/scripts/02_wait_til_nginx_is_up.sh
./ingress/nginx/tls/01_create_tls_cert.sh

printf "${green}\n\n====================================================================================================\n${egreen}"
printf "${green}\t\t\tEnable OIC for OpenFaaS Gateway\n${egreen}"
printf "${green}====================================================================================================\n\n${egreen}"

./scripts/04_enable_oic_for_openfaas.sh
