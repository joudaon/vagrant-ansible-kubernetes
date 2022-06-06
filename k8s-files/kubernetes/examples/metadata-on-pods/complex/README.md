# metadata_on_pods

- [metadata_on_pods](#metadata_on_pods)
  - [How to deploy](#how-to-deploy)

This example displays a basic html web with running application information like Pod Name, Pod Namespace, Pod Ip...

## How to deploy

1. Build docker image and push to docker hub registry

```sh
$> cd docker/
$> docker build . -t flask-server:latest
$> docker tag flask-server:latest joudaon/flask-server:latest
$> docker push joudaon/flask-server:latest
```

2. Update `image` tag on deployment.yaml file.

3. If working with minikube enable ingress addon:

```sh
$> minikube addons enable ingress
```

4. Deploy `deployment.yaml` file.

5. If using NodePort, go to Web UI and check NodePort:
   
   1. NodePort

    ```sh
    $> $(minikube ip):30002
    $> <k8s-master ip>:30002
    ```

   2. If using ingress:

    ```sh
    $> $(minikube ip)/flask
    $> <

   3. fda

