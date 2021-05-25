# metadata_on_pods

This example displays a basic html web with running application information like Pod Name, Pod Namespace, Pod Ip...

1. Build docker image and push to docker hub registry

```sh
$> cd docker/
$> docker build . -t flask-server:latest
$> docker tag flask-server:latest joudaon/flask-server:latest
$> docker push joudaon/flask-server:latest
```

2. Update `image` tag on deployment.yaml file.

3. Deploy `deployment.yaml` file.

4. Go to Web UI and check NodePort (improve this with ingress)

```sh
$> $(minikube ip):30002
$> <k8s-master ip>:30002
```