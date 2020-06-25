```sh
# Describe service
$> kubectl describe service my-service
# Get service information
$> kubectl get service my-service -o yaml
# Get current enpoints of the service
$> kubectl describe endpoints my-service
# Get nginx on nodeport (on k8s-master)
$> curl localhost:<nodeport(~30000)>
```