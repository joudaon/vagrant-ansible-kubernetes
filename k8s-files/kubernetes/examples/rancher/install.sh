#!/bin/bash

## Set virtualbox as default driver
minikube config set driver virtualbox

## Start minikube
echo "--> Starting minikube cluster-1"
minikube start --addons=metrics-server --addons=ingress --memory 8192 --cpus 2 --kubernetes-version=v1.26.3 -p cluster-1

# Add the Jetstack Helm repository (for cert-manager)
echo "--> Adding rancher repository"
helm repo add jetstack https://charts.jetstack.io
helm repo update

# Install the cert-manager Helm chart
echo "--> Installing cert-manager"
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.12.0 \
  --set installCRDs=true \
  --wait

# Add rancher Helm repository
echo "--> Adding rancher repository"
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
helm repo update

echo "--> Installing rancher"
kubectl create namespace cattle-system
helm install rancher rancher-stable/rancher \
  --namespace cattle-system \
  --set ingress.tls.source=rancher \
  --set hostname=myrancherminikube.com \
  --set replicas=2 \
  --set bootstrapPassword=admin \
  --version=2.7.5 \
  --wait

## Start minikube
echo "--> Starting minikube cluster-2"
minikube start --memory 8192 --cpus 2 --kubernetes-version=v1.26.3 -p cluster-2