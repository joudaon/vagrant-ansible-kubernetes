#!/bin/bash

MINIKUBE_VERSION="v1.25.1"

echo "----> Installing minikube."

cd /tmp
curl -Lo minikube https://github.com/kubernetes/minikube/releases/download/$MINIKUBE_VERSION/minikube-linux-amd64
chmod +x minikube
cp minikube /usr/local/bin && rm minikube
echo "Minikube Version --> $(minikube version)"

echo "--> Minikube successfully installed."
