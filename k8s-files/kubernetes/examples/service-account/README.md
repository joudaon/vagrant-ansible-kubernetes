# Service account usage

This example shows how to login into AKS Cluster using a Service Account.

## How to deploy

1. Run `roles.yaml`.

```
$> kubectl apply -f roles.yaml
```

2. Update `secret name` on `create-config-file.sh` and run the script.

```
$> kubectl get secrets -n jenkins-ns | grep jenkins | awk '{print $1}'
$> ./create-config-file.sh
```

3. Export `KUBECONFIG` as environment variable.

```
$> export KUBECONFIG=/home/vagrant/k8s-files/kubernetes/examples/service-account/sa.kubeconfig
```

4. Run the following command to check one pod is up.

```
$> kubectl get pods
```

## How to decode token

```
$> echo <token> | base64 --decode
```

## Useful links

- [Configure Service Accounts for Pods](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/)
- [Authenticating](https://kubernetes.io/docs/reference/access-authn-authz/authentication/)
- [Using RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)
- [Create Kubernetes Service Accounts and Kubeconfigs](https://docs.armory.io/docs/armory-admin/manual-service-account/)
- [How to create a kubectl config file for serviceaccount](https://stackoverflow.com/questions/47770676/how-to-create-a-kubectl-config-file-for-serviceaccount)
- [How to configure kubectl with cluster information from a .conf file?](https://stackoverflow.com/questions/40447295/how-to-configure-kubectl-with-cluster-information-from-a-conf-file)