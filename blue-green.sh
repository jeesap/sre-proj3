#!/bin/bash

kubectl apply -f starter/apps/blue-green/index_green_html.yml
kubectl apply -f starter/apps/blue-green/green.yml

# Check status of Deployment

kubectl rollout status deployment green -n udacity
