#!/bin/bash

set -e

FILE="helm/streamingapp/templates/ingress.yaml"

python3 - <<'PY'
from pathlib import Path

p = Path("helm/streamingapp/templates/ingress.yaml")
text = p.read_text()

replacements = {
    'name: {{ include "streamingapp.fullname" $ }}-chat-service':
        'name: {{ .Values.services.chat.name }}',

    'name: {{ include "streamingapp.fullname" $ }}-streaming-service':
        'name: {{ .Values.services.streaming.name }}',

    'name: {{ include "streamingapp.fullname" $ }}-admin-service':
        'name: {{ .Values.services.admin.name }}',

    'name: {{ include "streamingapp.fullname" $ }}-auth-service':
        'name: {{ .Values.services.auth.name }}',

    'name: {{ include "streamingapp.fullname" $ }}-frontend':
        'name: {{ .Values.services.frontend.name }}',
}

for old, new in replacements.items():
    text = text.replace(old, new)

p.write_text(text)

print("Ingress service names updated.")
PY

echo
echo "Validating Helm chart..."
helm lint helm/streamingapp

echo
echo "Rendering Helm chart..."
helm template streamingapp helm/streamingapp > /tmp/streamingapp-rendered.yaml

echo
echo "Ingress backend services:"
grep -A3 "backend:" /tmp/streamingapp-rendered.yaml | head -40
