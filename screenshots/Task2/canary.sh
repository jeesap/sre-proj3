#!/bin/bash

# Canary-v2 deployment
kubectl apply -f starter/apps/canary/index_v2_html.yml
kubectl apply -f starter/apps/canary/canary-v2.yml
kubectl apply -f starter/apps/canary/canary-svc.yml
sleep 2

# display Cluster IP
kubectl get svc canary-svc

# Begin canary deployment
kubectl scale deployment canary-v2 --replicas=2
kubectl scale deployment canary-v1 --replicas=2

# Check deployment rollout status every 1 second until complete.
ATTEMPTS=0
ROLLOUT_STATUS_CMD="kubectl rollout status deployment/canary-v2 -n udacity"
until $ROLLOUT_STATUS_CMD || [ $ATTEMPTS -eq 60 ]; do
  $ROLLOUT_STATUS_CMD
  ATTEMPTS=$((attempts + 1))
  sleep 1
done

NUM_OF_V1_PODS=$(kubectl get pods -n udacity | grep -c canary-v1)
echo "V1 PODS: $NUM_OF_V1_PODS"
NUM_OF_V2_PODS=$(kubectl get pods -n udacity | grep -c canary-v2)
echo "V2 PODS: $NUM_OF_V2_PODS"

echo "Canary deployment of v2 Completed"
