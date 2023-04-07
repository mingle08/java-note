#! /bin/bash
# perform health check

appSystemInfoPath=$( cd "$( dirname "$0"  )" && pwd )
echo $appSystemInfoPath
scriptname=app_system_info
function check_api {
  echo "do check api gateway"
}

function check_app {
  echo "do check app system"
  count=1
  cat $appSystemInfoPath/$scriptname | while read line
  do
    echo "Line $count:$line"
    count=$[ $count + 1 ]
  done
  echo "Finished processing app system"
  exit
}


echo
case $1 in 
"apigw")
  check_api;;
"appsys")
  check_app;;
*)
  echo "$1 is not an option";;
esac
