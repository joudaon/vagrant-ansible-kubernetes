#!/bin/bash

## Set docker as default driver
minikube config set driver docker

## Start minikube
minikube start --memory 8192 --cpus 4

## Download istio
curl -L https://istio.io/downloadIstio | sh -

## Install istio. This will create istiod and gateways (load balancers)
kubectl create namespace loadbalancer-internal
kubectl create namespace loadbalancer-external
istio-1.16.1/bin/istioctl operator init
kubectl apply -f istio_config/istiocontrolplane.yaml
kubectl apply -f istio_config/ingressgateways.yaml

