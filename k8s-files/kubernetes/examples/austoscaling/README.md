# Autoscaling

## How to deploy

1. Start minikube, enable 'metrics-server' and deploy 'php-apache'.

```sh
$> ./deploy.sh
```

2. Increase load

```sh
$> kubectl run -i --tty load-generator --rm --image=busybox --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://php-apache; done"
```

3. Check pods have been increased

## Uninstall

```sh
$> ./uninstall.sh
```

## Useful commands

```sh
$> kubectl top nodes
```
kubectl top nodes

## Useful links

- [Horizontal Pod Autoscaler Walkthrough](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/)