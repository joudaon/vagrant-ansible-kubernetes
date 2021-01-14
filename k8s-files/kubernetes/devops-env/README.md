# devops env

The aim of this configuration is to have an `nginx ingress controller` example.

## How to deploy 

### Create web certificates

```
$> openssl req -nodes -new -x509 -keyout server.key -out server.cert -subj "/C=GB/ST=London/L=London/O=Global Security/OU=IT Department CN=example.com"
```

### Deploy minikube

First, we create the minikube cluster.

```sh
$> minikube start --memory 4096 --nodes 3
```

We enable Ingress addon.

```sh
$> minikube addons enable ingress
```

We first create the namespace.

```sh
$> kubectl apply -f namespace-apps.yml
```

We create ingress-tls secret:

```sh
$> ./setup.sh
```

We apply this folder files.

```sh
$> kubectl apply -f .
```

If everything is ok, the ingress will have an `Address`. We add the following entry to the `/etc/hosts` file:

```
<nginx-controller-addres-ip> jenkins.devopsapps.com webconsole.devopsapps.com
```

Finally we go to the browser and we navigate to either of the entries.

## Useful links

- [k8s resources](https://github.com/ricardoandre97/k8s-resources)