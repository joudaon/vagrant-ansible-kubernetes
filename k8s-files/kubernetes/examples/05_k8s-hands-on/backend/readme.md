Example from: https://www.udemy.com/course/kubernetes-de-principiante-a-experto/

Testing app:
$> docker run --rm -dti -v $PWD:/go --net host --name golang golang bash
$> docker exec -ti golang /bin/bash
$> go run main.go

Create docker image:
$> docker build -t k8s-hands-on .
$> docker run -d -p 9091:9090 --name k8s-hands-on k8s-hands-on

Image can be downloaded from: ricardoandre97/backend-k8s-hands-on:v1