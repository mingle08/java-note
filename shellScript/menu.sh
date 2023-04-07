#! /bin/bash
# menu

function healthCheckMenu {
  clear
  echo
  echo -e "\t\t\tCommon API Gateway\n\n"
  echo -e "\t\t1. Health Check for Api Gateway"
  echo -e "\t\t2. Health Check for App System"
  echo -e "\t\t0. Exit Menu\n"
  read -n 1 option
}

while [ 1 ]
do
  healthCheckMenu
  case $option in
  0)
    break;;
  1)
    echo "dirname: `dirname $0`"
    . ./healthChk_api_gateway.sh;;
  2)
    . ./healthChk_app_system.sh;;
  *)
      clear
      echo "Sorry, wrong selection";;
  esac
  echo -en "\n\n\t\t\tHit any key to continue"
  read -n 1 line
done
clear
