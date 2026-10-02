#!/bin/bash
set -e

FILE="helm/streamingapp/templates/mongodb.yaml"

echo "Updating MongoDB PVC StorageClass..."

if grep -q "storageClassName:" "$FILE"; then
    echo "storageClassName already exists. Updating it to gp2..."
    sed -i 's/^[[:space:]]*storageClassName:.*/  storageClassName: gp2/' "$FILE"
else
    echo "Adding storageClassName: gp2..."
    sed -i '/^[[:space:]]*accessModes:/a\  storageClassName: gp2' "$FILE"
fi

echo
echo "Updated PVC section:"
grep -A10 -B2 "kind: PersistentVolumeClaim" "$FILE"

echo
echo "Running Helm lint..."
helm lint helm/streamingapp

echo
echo "Done."
