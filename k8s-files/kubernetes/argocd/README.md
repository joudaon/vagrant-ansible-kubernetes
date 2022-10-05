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

Run `bootstrap.yaml` application file to create all the applications inside `application` folder.

```sh
$> kubectl apply -f bootstrap.yaml
```

# Documentation

- [Argo CD - Declarative GitOps CD for Kubernetes](https://argo-cd.readthedocs.io/en/stable/)
- [Implementando GitOps con ArgoCD](https://www.adictosaltrabajo.com/2020/05/25/implementando-gitops-con-argocd/)
- [Helm chart + values files from Git](https://github.com/argoproj/argo-cd/issues/2789#issuecomment-574821873)
- [Feature: External Helm values from git](https://github.com/argoproj/argo-cd/pull/6280)
- [One option to setup an app-of-apps example in Argo CD](https://suedbroecker.net/2022/08/22/one-option-to-setup-an-app-of-apps-example-in-argo-cd/)