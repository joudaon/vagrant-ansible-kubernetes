#!/bin/bash

# Dowload page: https://github.com/helm/helm/releases

helm_version="helm-v3.1.2-linux-amd64.tar.gz"

echo "--> Installing helm."

cd /tmp
wget https://get.helm.sh/$helm_version
tar -zxvf $helm_version
cp linux-amd64/helm /usr/local/bin/helm
rm -rf $helm_version linux-amd64/

echo "--> Helm successfully installed."