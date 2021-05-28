# minikube cheatsheet

```sh
# start minikube with docker engine
minikube start --driver=docker
# start minikube with custom memory and custom nodes
minikube start --memory 4096 --nodes 3
# enable ingress addon
minikube addons enable ingress
# enable metrics-server addon
minikube addons enable metrics-server
# Getting the NodePort using the service command
minikube service --url <service-name>
# Get minikube node list
minikube node list
```