# ingress-nginx-minikube

- [ingress-nginx-minikube](#ingress-nginx-minikube)
  - [How to deploy](#how-to-deploy)

This example show how to deploy ingress-nginx controller in minikube cluster

## How to deploy

1. Deploy minikube cluster with `ingress` addon:

```sh
./deploy-minikube.sh
```

2. Deploy kubernetes manifests:

```sh
kubectl apply -f .
```

3. Check everything is ok by going to:
   

```sh
$> $(minikube ip)
```


