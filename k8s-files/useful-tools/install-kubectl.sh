#!/bin/bash

KUBECTL_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)

echo "----> Installing kubectl."

cd /tmp
curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl version
echo "kubectl Version --> $(kubectl version)"

echo "--> kubectl successfully installed."
