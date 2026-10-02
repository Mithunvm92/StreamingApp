#!/bin/bash

set -e

FILE="helm/streamingapp/templates/backend.yaml"

python3 - <<'PY'
from pathlib import Path

p = Path("helm/streamingapp/templates/backend.yaml")
text = p.read_text()

old = 'value: "mongodb://mongo:27017/streamingapp"'
new = 'value: "mongodb://{{ .Values.services.mongo.name }}:27017/{{ .Values.mongodb.database }}"'

if old in text:
    text = text.replace(old, new)
elif 'value: mongodb://mongo:27017/streamingapp' in text:
    text = text.replace(
        'value: mongodb://mongo:27017/streamingapp',
        'value: "mongodb://{{ .Values.services.mongo.name }}:27017/{{ .Values.mongodb.database }}"'
    )
else:
    print("Expected MongoDB URI was not found.")
    raise SystemExit(1)

p.write_text(text)
print("Backend MongoDB URL updated in Helm template.")
PY

echo
echo "Checking MongoDB URI in Helm template:"
grep -n -A2 -B2 "MONGO_URI" "$FILE"

echo
echo "Validating Helm:"
helm lint helm/streamingapp

echo
echo "Rendering Helm:"
helm template streamingapp helm/streamingapp > /tmp/streamingapp-rendered.yaml

echo
echo "Rendered MongoDB URI:"
grep -n -A2 "MONGO_URI" /tmp/streamingapp-rendered.yaml
