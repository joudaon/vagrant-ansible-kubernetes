#!/bin/bash

# Start Minikube with a built-in Calico implementation, this is a quick way to checkout Calico features.
minikube start --memory 4096 --network-plugin=cni --cni=calico
sleep 30s

# Verify Calico installation in your cluster by issuing the following command.
# watch kubectl get pods -l k8s-app=calico-node -A

# Install calico - https://projectcalico.docs.tigera.io/maintenance/clis/calicoctl/install
curl -L https://github.com/projectcalico/calico/releases/download/v3.23.1/calicoctl-linux-amd64 -o calicoctl
chmod +x ./calicoctl