#!/bin/bash

# Create the Helm chart directory and navigate into it
mkdir my-express-app-chart
cd my-express-app-chart

# Create the required files and directories inside the Helm chart directory
touch Chart.yaml
mkdir templates
touch values.yaml

# Write content to Chart.yaml
cat << EOF > Chart.yaml
apiVersion: v2
name: my-express-app-chart
description: A Helm chart for deploying the Express app
version: 0.1.0
EOF

# Write content to values.yaml
cat << EOF > values.yaml
replicaCount: 5
image:
  repository: 961146733711.dkr.ecr.us-west-2.amazonaws.com/lifebit-dev-default-ecrrepo-01
  tag: 202307231554
  pullPolicy: IfNotPresent

service:
  type: LoadBalancer
  port: 80
  targetPort: 3000
EOF

# Create the required Kubernetes manifest files inside the templates directory
mkdir templates

# Write content to deployment.yaml
cat << EOF > templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "my-express-app-chart.fullname" . }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      app: {{ include "my-express-app-chart.fullname" . }}
  template:
    metadata:
      labels:
        app: {{ include "my-express-app-chart.fullname" . }}
    spec:
      containers:
        - name: express
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          ports:
            - containerPort: 3000
EOF

# Write content to service.yaml
cat << EOF > templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: {{ include "my-express-app-chart.fullname" . }}
spec:
  selector:
    app: {{ include "my-express-app-chart.fullname" . }}
  ports:
    - protocol: TCP
      port: {{ .Values.service.port }}
      targetPort: {{ .Values.service.targetPort }}
  type: {{ .Values.service.type }}
EOF

echo "Helm chart directory and files created successfully!"
