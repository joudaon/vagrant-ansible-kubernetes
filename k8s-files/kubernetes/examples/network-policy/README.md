# Network policy

This example shows how Network Policy works in Kubernetes.

## How to deploy

1. Start Minikube with Calico Network plugin.

```sh
$> ./install-calico.sh
```

2. Run all the `yaml` files.

```sh
$> kubectl apply -f namespace-1.yaml
$> kubectl apply -f namespace-2.yaml
```

It will create 2 namespaces (`namespace-1` and `namespace-2`):

## Debugging

Go to `namespace-1` and enter into `busybox-improved` container.

```sh
# Run the following command to get service ip
$> nslookup apache
$> nslookup apache.namespace-1.svc.cluster.local
$> nslookup nginx
$> nslookup nginx.namespace-1.svc.cluster.local

# Curl services by running
$> curl apache:8080
$> curl apache.namespace-1.svc.cluster.local:8080
$> curl nginx:8080
$> curl nginx.namespace-1.svc.cluster.local:8080
```

These are `namespace-1` services. Let's go to `namespace-2` services:

```sh
# Run the following command to get service ip
$> nslookup apache.namespace-2.svc.cluster.local
$> nslookup nginx.namespace-2.svc.cluster.local

# Curl services by running
$> curl apache.namespace-2.svc.cluster.local:8080
$> curl nginx.namespace-2.svc.cluster.local:8080
```

Now if you run `network-policy-deny-all.yaml` communications between all pods will be denied.

## Useful files
- [Install Calico Minikube](https://projectcalico.docs.tigera.io/getting-started/kubernetes/minikube)