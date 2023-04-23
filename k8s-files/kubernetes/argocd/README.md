# Getting started

- [Getting started](#getting-started)
  - [Requirements](#requirements)
  - [Setup](#setup)
  - [Create applications](#create-applications)
  - [Creating local users/accounts](#creating-local-usersaccounts)
  - [RBAC](#rbac)
  - [Multiple Kubernetes Cluster in ArgoCD](#multiple-kubernetes-cluster-in-argocd)
- [Documentation](#documentation)

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

## Create applications

Run `bootstrap.yaml` application file to create all the applications inside `application` folder.

```sh
$> kubectl apply -f bootstrap.yaml
```

## Creating local users/accounts

Login and download `argo-cm.yaml` config map file:

```sh
$> argocd login localhost:8080 --username admin
$> argocd account list
$> kubectl get configmap argocd-cm -n argocd -o yaml > argocd-cm.yml
```

Add the following text block to the `argo-cm.yaml` file:

```yaml
data:
  accounts.joudaon: login
```

Update user password:

```sh
# if you are managing users as the admin user, <current-user-password> should be the current admin password.
$> argocd account update-password \
  --account <name> \
  --current-password <current-user-password> \
  --new-password <new-user-password>
```

## RBAC

Download `argocd-rbac.yml` config map file

```sh
$> kubectl get configmap argocd-rbac-cm -n argocd -o yaml > argocd-rbac.yml
```

Add the following text block to the `argocd-rbac.yml` file:

```yaml
data:
  policy.csv: |
    p, role:org-admin, applications, *, */*, allow
    g, joudaon, role:org-admin
  policy.default: role:''
```

Now user should be able to log in and see applications.

- [Create a New User in ArgoCD using the CLI and ConfigMap](https://medium.com/geekculture/create-a-new-user-in-argocd-using-the-cli-and-configmap-8cbb27cf5904)

## Multiple Kubernetes Cluster in ArgoCD

Start 2 minikube instances (they must be in the same network):

```sh
$> minikube start -p cluster1 --addons=dashboard --addons=metrics-server --addons=ingress --addons=registry --memory=3gb --vm-driver=virtualbox
$> minikube start -p cluster2 --addons=dashboard --addons=metrics-server --addons=ingress --addons=registry --memory=3gb --vm-driver=virtualbox
$> minikube profile list
# Switch to cluster1 context
$> kubectl config use-context cluster1
```

Login into argocd cli and run the following command:

```sh
$> argocd login localhost:8080 --username admin
$> argocd cluster add cluster2
$> argocd cluster list
```

Update application yaml to point destination cluster name to `cluster2`

# Documentation

- [Argo CD - Declarative GitOps CD for Kubernetes](https://argo-cd.readthedocs.io/en/stable/)
- [Implementando GitOps con ArgoCD](https://www.adictosaltrabajo.com/2020/05/25/implementando-gitops-con-argocd/)
- [Helm chart + values files from Git](https://github.com/argoproj/argo-cd/issues/2789#issuecomment-574821873)
- [Feature: External Helm values from git](https://github.com/argoproj/argo-cd/pull/6280)
- [One option to setup an app-of-apps example in Argo CD](https://suedbroecker.net/2022/08/22/one-option-to-setup-an-app-of-apps-example-in-argo-cd/)
- [](https://github.com/argoproj/argo-cd/issues/4204)