#!/bin/bash

##### Constants

BOLD="\e[1m"
NOBOLD="\e[21m"
UNDERLINE="\e[4m"
NOUNDERLINE="\e[24m"
GREEN='\e[32m'
RED='\e[31m'
RESTORE='\033[0m'
LIGHTCYAN='\e[96m'
MAGENTA='\e[95m'

##### Functions

usage()
{
  echo -e "${BOLD}${UNDERLINE}Usage:${RESTORE} $0"
}

create_secrets() {
  echo -e "--> Creating '${GREEN}${BOLD}ingress-tls${NOBOLD}${RESTORE}' tls secret which contains https server cert"
  kubectl create secret tls ingress-tls --key server.key --cert server.cert --namespace=devops-apps
}

##### Main

if [ $# -ne 0 ]; then
  echo -e "${RED}ERROR!${RESTORE}"
  usage
  exit
fi

create_secrets $1
