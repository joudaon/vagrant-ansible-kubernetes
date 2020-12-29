#!/bin/bash

HELM_VERSION="helm-v3.4.2-linux-amd64.tar.gz"
K9S_VERSION="v0.24.2"

####################
####### helm #######
####################

# Download page: https://github.com/helm/helm/releases

if [ ! -f /usr/local/bin/helm ]; then

  echo "----> Installing helm."

  cd /tmp
  wget https://get.helm.sh/$HELM_VERSION
  tar -zxvf $HELM_VERSION
  cp linux-amd64/helm /usr/local/bin/helm
  rm -rf $HELM_VERSION linux-amd64/
  echo "Helm Version --> $(helm version)"

  echo "--> helm successfully installed."

else

  echo "--> PACKAGE: 'helm' already installed!"

fi

#################
###### k9s ######
#################

if [ ! -f /usr/local/bin/k9s ]; then

  cd /tmp
  wget https://github.com/derailed/k9s/releases/download/$K9S_VERSION/k9s_Linux_x86_64.tar.gz
  tar -zxvf k9s_Linux_x86_64.tar.gz
  cp k9s /usr/local/bin/k9s

  rm -rf k9s_Linux_x86_64.tar.gz k9s LICENCE README.md
  echo "k9s Version --> $(k9s version)"

  echo "--> k9s successfully installed."

else

  echo "--> PACKAGE: 'k9s' already installed!"

fi