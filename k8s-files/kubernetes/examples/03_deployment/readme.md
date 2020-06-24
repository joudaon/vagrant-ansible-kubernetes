```sh
# Get Deployment history
$> kubectl rollout history deployment deployment-test
# Get Deployment concrete revision changes
$> kubectl rollout history deployment deployment-test --revision=2
# Update rollout history cause on CLI 
$> kubectl apply -f deployment.yaml --record
# Rollback to a previous version
$> kubectl rollout unde deployment deployment-test --to-revision=1
```