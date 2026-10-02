#!/bin/bash

set -e

NAMESPACE="streamingapp"
MONGO_URL="mongodb://streamingapp-mongo:27017/streamingapp"

echo "Updating MongoDB URL to: $MONGO_URL"

for DEPLOYMENT in \
  streamingapp-auth \
  streamingapp-streaming \
  streamingapp-admin \
  streamingapp-chat
do
  echo "Updating $DEPLOYMENT..."

  kubectl set env deployment/$DEPLOYMENT \
    MONGO_URI="$MONGO_URL" \
    -n "$NAMESPACE"
done

echo
echo "Waiting for deployments to restart..."

kubectl rollout status deployment/streamingapp-auth -n "$NAMESPACE"
kubectl rollout status deployment/streamingapp-streaming -n "$NAMESPACE"
kubectl rollout status deployment/streamingapp-admin -n "$NAMESPACE"
kubectl rollout status deployment/streamingapp-chat -n "$NAMESPACE"

echo
echo "Current pod status:"
kubectl get pods -n "$NAMESPACE"

echo
echo "MongoDB URL update completed."
