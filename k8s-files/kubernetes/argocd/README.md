# Getting started

## Requirements

- Minikube
- Helm

## Setup

1. Start minikube cluster

```sh
$> minikube start --addons=dashboard --addons=metrics-server --addons=ingress --addons=registry --cpus=4 --memory=8gb
```

2. Install ArgoCD

This will create a new namespace, argocd, where Argo CD services and application resources will live.

```sh
$> kubectl create namespace argocd
$> kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
$> kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
$> kubectl port-forward svc/argocd-server -n argocd 8080:443
$> kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```

The API server can then be accessed using https://localhost:8080

# Documentation

- [Argo CD - Declarative GitOps CD for Kubernetes](https://argo-cd.readthedocs.io/en/stable/)
- [Implementando GitOps con ArgoCD](https://www.adictosaltrabajo.com/2020/05/25/implementando-gitops-con-argocd/)