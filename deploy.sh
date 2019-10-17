
green=$'\e[1;32m'
egreen=$'\e[0m'

printf "${green}====================================================================================================\n${egreen}"
printf "${green}\t\t\t\tStart Minikube\n${egreen}"
printf "${green}====================================================================================================\n\n${egreen}"

./scripts/01_start_minikube.sh

printf "${green}\n\n====================================================================================================\n${egreen}"
printf "${green}\t\t\t\tInstall Tiller\n${egreen}"
printf "${green}====================================================================================================\n\n${egreen}"

./scripts/02_install_tiller.sh

printf "${green}\n\n====================================================================================================\n${egreen}"
printf "${green}\t\t\t\tWait til Tiller is up...\n${egreen}"
printf "${green}====================================================================================================\n\n${egreen}"

./scripts/03_wait_til_tiller_is_up.sh

printf "${green}\n\n====================================================================================================\n${egreen}"
printf "${green}\t\t\t\tInstall OpenFaaS\n${egreen}"
printf "${green}====================================================================================================\n\n${egreen}"

./scripts/04_install_openfaas.sh

printf "${green}\n\n====================================================================================================\n${egreen}"
printf "${green}\t\t\t\tWait til OpenFaaS is up...\n${egreen}"
printf "${green}====================================================================================================\n\n${egreen}"

./scripts/05_wait_til_openfaas_is_up.sh

printf "${green}\n\n====================================================================================================\n${egreen}"
printf "${green}\t\t\t\tTest Setup\n${egreen}"
printf "${green}====================================================================================================\n\n${egreen}"

./scripts/06_test_setup.sh

printf "${green}\n\n====================================================================================================\n${egreen}"
printf "${green}\t\t\t\tInstall Kong\n${egreen}"
printf "${green}====================================================================================================\n\n${egreen}"

./ingress/kong/scripts/01_install_kong_ingress_controller.sh
./ingress/kong/scripts/02_wait_til_kong_is_up.sh
./ingress/kong/scripts/03_enable_routing.sh

printf "${green}\n\n====================================================================================================\n${egreen}"
printf "${green}\t\t\t\tDeploy sample functions\n${egreen}"
printf "${green}====================================================================================================\n\n${egreen}"

./functions/deploy_functions.sh

printf "${green}\n\n====================================================================================================\n${egreen}"
printf "${green}\t\t\tEnable Basic Authentication for functions\n${egreen}"
printf "${green}====================================================================================================\n\n${egreen}"

./ingress/kong/auth/enable_basic_auth.sh

printf "${green}\n\n====================================================================================================\n${egreen}"
printf "${green}\t\t\tEnable OIC for OpenFaaS Gateway\n${egreen}"
printf "${green}====================================================================================================\n\n${egreen}"

./scripts/07_enable_oic_for_openfaas.sh
