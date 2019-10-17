blue=$'\e[1;34m'
eblue=$'\e[0m'

green=$'\e[1;32m'
egreen=$'\e[0m'

printf "${green}\n\n====================================================================================================\n${egreen}"
printf "${green}\t\t\t\tLogin to OpenFaaS Gateway with OID-Connect\n${egreen}"
printf "${green}====================================================================================================\n\n${egreen}"

faas-cli auth \
  --auth-url ${AUTH_URL} \
  --audience ${AUDIENCE_URL} \
  --client-id ${CLIENT_ID}

echo "\nYou have to save the received token with ${blue}export TOKEN=\"\"${eblue}"
