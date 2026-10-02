#!/bin/bash

set -e

NAMESPACE="streamingapp"
DEPLOYMENT="streamingapp-mongo"

echo "Changing MongoDB deployment strategy to Recreate..."

kubectl patch deployment "$DEPLOYMENT" \
  -n "$NAMESPACE" \
  --type='strategic' \
  -p '{"spec":{"strategy":{"type":"Recreate"}}}'

echo
echo "Deleting the currently failing MongoDB pod..."

kubectl delete pod \
  -n "$NAMESPACE" \
  -l app=streamingapp-mongo \
  --field-selector=status.phase!=Running \
  --ignore-not-found

echo
echo "Waiting for MongoDB rollout..."

kubectl rollout status deployment/"$DEPLOYMENT" \
  -n "$NAMESPACE" \
  --timeout=180s

echo
echo "MongoDB status:"
kubectl get pods -n "$NAMESPACE" -l app=streamingapp-mongo

echo
echo "MongoDB service:"
kubectl get svc streamingapp-mongo -n "$NAMESPACE"

echo
echo "MongoDB endpoints:"
kubectl get endpoints streamingapp-mongo -n "$NAMESPACE"
