# Network policy

This example shows how Network Policy works in Kubernetes.

## How to deploy

1. Start Minikube with Calico Network plugin.

```sh
$> ./install-calico.sh
```

2. Run all the `yaml` files.

```sh
$> kubectl apply -f .
```

## Useful files
- [Install Calico Minikube](https://projectcalico.docs.tigera.io/getting-started/kubernetes/minikube)