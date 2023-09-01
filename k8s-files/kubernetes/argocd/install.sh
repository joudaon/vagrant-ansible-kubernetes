#!/bin/bash

## Set virtualbox as default driver
minikube config set driver virtualbox

## Start Minikube
echo "--> Starting minikube cluster-1"
minikube start --addons=dashboard --addons=metrics-server --addons=ingress --addons=registry --cpus=2 --memory=8gb -p cluster-1

## Install argocd
echo "--> Installing argocd"
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl expose deployment argocd-server --type=NodePort --name=argocd-service --namespace=argocd
sleep 30s

## Install External Secrets Operator (https://github.com/external-secrets/external-secrets)(https://github.com/hashicorp/vault-helm/issues/17)
helm repo add external-secrets https://charts.external-secrets.io
helm install external-secrets external-secrets/external-secrets -n external-secrets --create-namespace --wait

## Install Argo Rollouts
kubectl create namespace argo-rollouts
kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml

## Install Argo CD Image Updater (https://argocd-image-updater.readthedocs.io/en/stable/)
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj-labs/argocd-image-updater/stable/manifests/install.yaml

## Install Argo CD Notifications (https://argocd-notifications.readthedocs.io/en/stable/)
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj-labs/argocd-notifications/release-1.0/manifests/install.yaml

## Get credentials
echo "--> Installation finished!"
NODEPORT=$(kubectl get service argocd-service --namespace=argocd -ojsonpath='{.spec.ports[0].nodePort}')
ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo "argocd URL --> $(minikube ip -p cluster-1):$NODEPORT"
echo "argocd username --> admin"
echo "argocd password --> $ARGOCD_PASSWORD"

# Create sample applications
# kubectl apply -f bootstrap.yaml

## Start Minikube
echo "--> Starting minikube cluster-2"
minikube start --cpus=2 --memory=8gb -p cluster-2