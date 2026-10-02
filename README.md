Yes. Below is a **complete submission-ready README** containing the project architecture, AWS setup, Docker, ECR, Jenkins, EKS, Helm, ALB, MongoDB persistence, HPA, validation, troubleshooting, and the important commands in **Bash code blocks**.

You can replace your current `README.md` with this entire content.

````markdown
# StreamingApp – MERN Application on AWS EKS

A MERN-based video streaming application containerized with Docker and deployed on Amazon EKS using Helm, Amazon ECR, Jenkins CI/CD, AWS Application Load Balancer, persistent MongoDB storage, Kubernetes Metrics Server, and Horizontal Pod Autoscaling.

---

# 1. Project Overview

StreamingApp is a MERN-based streaming platform consisting of:

- React frontend
- Node.js/Express backend services
- MongoDB database
- Docker containers
- Amazon ECR
- Jenkins CI/CD
- Amazon EKS
- Helm
- AWS Application Load Balancer
- AWS EBS persistent storage
- Kubernetes Metrics Server
- Horizontal Pod Autoscaling

The application is divided into multiple backend services:

```text
Frontend
   |
   +-- Auth Service
   |
   +-- Streaming Service
   |
   +-- Admin Service
   |
   +-- Chat Service
   |
   +-- MongoDB
````

---

# 2. High-Level Architecture

```text
                           +----------------+
                           |     GitHub     |
                           | StreamingApp   |
                           +-------+--------+
                                   |
                                   | Git Push
                                   v
                           +----------------+
                           |    Jenkins     |
                           |     CI/CD      |
                           +-------+--------+
                                   |
                                   | Docker Build
                                   v
                    +-----------------------------+
                    |        Amazon ECR           |
                    |-----------------------------|
                    | streamingapp-frontend       |
                    | streamingapp-auth           |
                    | streamingapp-streaming      |
                    | streamingapp-admin          |
                    | streamingapp-chat           |
                    +-------------+---------------+
                                  |
                                  | Pull Images
                                  v
                    +-----------------------------+
                    |          Amazon EKS         |
                    |      streamingapp-eks       |
                    |                             |
                    |  +-----------------------+  |
                    |  | Kubernetes Namespace   |  |
                    |  | streamingapp          |  |
                    |  |                       |  |
                    |  | Frontend x2            |  |
                    |  | Auth x2                |  |
                    |  | Streaming x2           |  |
                    |  | Admin x2               |  |
                    |  | Chat x2                |  |
                    |  | MongoDB x1             |  |
                    |  +-----------------------+  |
                    +-------------+---------------+
                                  |
                                  v
                    +-----------------------------+
                    | AWS Application Load        |
                    | Balancer                    |
                    +-------------+---------------+
                                  |
              +-------------------+-------------------+
              |                   |                   |
              v                   v                   v

          Frontend               APIs              Socket.IO
              |                   |                   |
              |          +--------+--------+          |
              |          |        |        |          |
              v          v        v        v          v
           Frontend     Auth   Streaming  Admin      Chat
                                      |
                                      v
                                  MongoDB
                                      |
                                      v
                                   AWS EBS
```

---

# 3. Repository Structure

```text
StreamingApp/
│
├── backend/
│   ├── adminService/
│   │   └── Dockerfile
│   │
│   ├── authService/
│   │   └── Dockerfile
│   │
│   ├── chatService/
│   │   └── Dockerfile
│   │
│   └── streamingService/
│       └── Dockerfile
│
├── frontend/
│   └── Dockerfile
│
├── helm/
│   └── streamingapp/
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/
│           ├── _helpers.tpl
│           ├── backend.yaml
│           ├── frontend.yaml
│           ├── mongodb.yaml
│           ├── ingress.yaml
│           ├── hpa.yaml
│           └── secret.yaml
│
├── eks/
│   └── cluster.yaml
│
├── docs/
│   ├── DEPLOYMENT_DOCUMENTATION.md
│   ├── FINAL_SUBMISSION_CHECKLIST.md
│   └── evidence/
│
├── Jenkinsfile
├── docker-compose.yml
└── README.md
```

---

# 4. Application Components

| Component         |  Port | Kubernetes Service |
| ----------------- | ----: | ------------------ |
| Frontend          |    80 | frontend           |
| Auth Service      |  3001 | auth-service       |
| Streaming Service |  3002 | streaming-service  |
| Admin Service     |  3003 | admin-service      |
| Chat Service      |  3004 | chat-service       |
| MongoDB           | 27017 | streamingapp-mongo |

---

# 5. Backend Services

## Auth Service

Port:

```text
3001
```

Health endpoint:

```text
GET /health
```

---

## Streaming Service

Port:

```text
3002
```

Health endpoint:

```text
GET /api/health
```

Important routes:

```text
GET /api/streaming/stream/:videoId
GET /api/streaming/videos/:videoId/stream
GET /api/streaming/videos
GET /api/streaming/videos/featured
GET /api/streaming/videos/:videoId
GET /api/streaming/thumbnails/*
```

---

## Admin Service

Port:

```text
3003
```

Health endpoint:

```text
GET /api/health
```

Important routes:

```text
GET    /api/admin/videos
POST   /api/admin/videos/upload-urls
POST   /api/admin/videos/upload-urls/video
POST   /api/admin/videos/upload-urls/thumbnail
POST   /api/admin/videos/upload/video
POST   /api/admin/videos/upload/thumbnail
POST   /api/admin/videos
PUT    /api/admin/videos/:id
DELETE /api/admin/videos/:id
PATCH  /api/admin/videos/:id/featured
```

---

## Chat Service

Port:

```text
3004
```

Health endpoint:

```text
GET /api/health
```

Chat history:

```text
GET /api/chat/history/:videoId
```

Socket.IO:

```text
/socket.io
```

---

# 6. Local Development

Clone the repository:

```bash
git clone https://github.com/Mithunvm92/StreamingApp.git
cd StreamingApp
```

Check repository:

```bash
git status
```

Start the application using Docker Compose:

```bash
docker-compose up -d --build
```

Check containers:

```bash
docker-compose ps
```

View logs:

```bash
docker-compose logs -f
```

Stop the application:

```bash
docker-compose down
```

---

# 7. Docker Images

The application is containerized into five application images:

```text
streamingapp-frontend
streamingapp-auth
streamingapp-streaming
streamingapp-admin
streamingapp-chat
```

Build frontend:

```bash
docker build \
  -t streamingapp-frontend \
  ./frontend
```

Build Auth:

```bash
docker build \
  -t streamingapp-auth \
  ./backend/authService
```

Build Streaming:

```bash
docker build \
  -t streamingapp-streaming \
  -f ./backend/streamingService/Dockerfile \
  ./backend
```

Build Admin:

```bash
docker build \
  -t streamingapp-admin \
  -f ./backend/adminService/Dockerfile \
  ./backend
```

Build Chat:

```bash
docker build \
  -t streamingapp-chat \
  -f ./backend/chatService/Dockerfile \
  ./backend
```

Check local images:

```bash
docker images
```

---

# 8. AWS Configuration

AWS Region:

```text
ap-south-1
```

AWS Account:

```text
075237969193
```

ECR registry:

```text
075237969193.dkr.ecr.ap-south-1.amazonaws.com
```

Configure AWS CLI:

```bash
aws configure
```

Verify AWS identity:

```bash
aws sts get-caller-identity
```

Verify region:

```bash
aws configure get region
```

Expected region:

```text
ap-south-1
```

---

# 9. Amazon ECR

Five ECR repositories are used.

```text
streamingapp-frontend
streamingapp-auth
streamingapp-streaming
streamingapp-admin
streamingapp-chat
```

List repositories:

```bash
aws ecr describe-repositories \
  --region ap-south-1
```

Create repositories if required:

```bash
aws ecr create-repository \
  --repository-name streamingapp-frontend \
  --region ap-south-1

aws ecr create-repository \
  --repository-name streamingapp-auth \
  --region ap-south-1

aws ecr create-repository \
  --repository-name streamingapp-streaming \
  --region ap-south-1

aws ecr create-repository \
  --repository-name streamingapp-admin \
  --region ap-south-1

aws ecr create-repository \
  --repository-name streamingapp-chat \
  --region ap-south-1
```

Login to ECR:

```bash
aws ecr get-login-password \
  --region ap-south-1 | \
docker login \
  --username AWS \
  --password-stdin \
  075237969193.dkr.ecr.ap-south-1.amazonaws.com
```

---

# 10. ECR Image Tagging

Example:

```bash
docker tag streamingapp-frontend \
  075237969193.dkr.ecr.ap-south-1.amazonaws.com/streamingapp-frontend:build-4
```

Tag backend images:

```bash
docker tag streamingapp-auth \
  075237969193.dkr.ecr.ap-south-1.amazonaws.com/streamingapp-auth:build-4

docker tag streamingapp-streaming \
  075237969193.dkr.ecr.ap-south-1.amazonaws.com/streamingapp-streaming:build-4

docker tag streamingapp-admin \
  075237969193.dkr.ecr.ap-south-1.amazonaws.com/streamingapp-admin:build-4

docker tag streamingapp-chat \
  075237969193.dkr.ecr.ap-south-1.amazonaws.com/streamingapp-chat:build-4
```

Push images:

```bash
docker push \
  075237969193.dkr.ecr.ap-south-1.amazonaws.com/streamingapp-frontend:build-4

docker push \
  075237969193.dkr.ecr.ap-south-1.amazonaws.com/streamingapp-auth:build-4

docker push \
  075237969193.dkr.ecr.ap-south-1.amazonaws.com/streamingapp-streaming:build-4

docker push \
  075237969193.dkr.ecr.ap-south-1.amazonaws.com/streamingapp-admin:build-4

docker push \
  075237969193.dkr.ecr.ap-south-1.amazonaws.com/streamingapp-chat:build-4
```

Check images:

```bash
aws ecr list-images \
  --repository-name streamingapp-frontend \
  --region ap-south-1

aws ecr list-images \
  --repository-name streamingapp-auth \
  --region ap-south-1

aws ecr list-images \
  --repository-name streamingapp-streaming \
  --region ap-south-1

aws ecr list-images \
  --repository-name streamingapp-admin \
  --region ap-south-1

aws ecr list-images \
  --repository-name streamingapp-chat \
  --region ap-south-1
```

---

# 11. Jenkins CI/CD

Jenkins is configured to build and push Docker images automatically.

Jenkins:

```text
https://jenkinsacademics.herovired.com/
```

Pipeline:

```text
GitHub
   |
   v
GitHub Webhook
   |
   v
Jenkins
   |
   +-- Checkout
   |
   +-- Verify Tools
   |
   +-- ECR Login
   |
   +-- Docker Build
   |
   +-- Docker Push
   |
   v
Amazon ECR
```

The Jenkins pipeline uses the build number as the Docker image tag.

Example:

```text
build-4
```

---

# 12. Jenkinsfile

The pipeline performs:

```text
Checkout
Verify Tools
ECR Login
Build Docker Images
Push Images to ECR
Deployment Summary
```

The pipeline uses:

```text
AWS Region:
ap-south-1

AWS Account:
075237969193
```

ECR registry:

```text
075237969193.dkr.ecr.ap-south-1.amazonaws.com
```

---

# 13. GitHub Webhook

Jenkins webhook:

```text
https://jenkinsacademics.herovired.com/github-webhook/
```

GitHub repository:

```text
https://github.com/Mithunvm92/StreamingApp.git
```

Branch:

```text
main
```

A push to the `main` branch triggers the Jenkins pipeline.

---

# 14. EKS Cluster

Cluster:

```text
streamingapp-eks
```

Region:

```text
ap-south-1
```

Kubernetes version:

```text
1.33
```

Node group:

```text
streamingapp-ng
```

Instance type:

```text
t3.small
```

Desired nodes:

```text
3
```

Minimum nodes:

```text
2
```

Maximum nodes:

```text
3
```

---

# 15. EKS Cluster Creation

The cluster configuration is stored at:

```text
eks/cluster.yaml
```

Create cluster:

```bash
eksctl create cluster -f eks/cluster.yaml
```

Check cluster:

```bash
eksctl get cluster \
  --region ap-south-1
```

Update kubeconfig:

```bash
aws eks update-kubeconfig \
  --region ap-south-1 \
  --name streamingapp-eks
```

Verify connection:

```bash
kubectl cluster-info
```

Check nodes:

```bash
kubectl get nodes
```

Detailed nodes:

```bash
kubectl get nodes -o wide
```

---

# 16. AWS Load Balancer Controller

The AWS Load Balancer Controller is used to create the Application Load Balancer from the Kubernetes Ingress resource.

Check controller:

```bash
kubectl get deployment \
  aws-load-balancer-controller \
  -n kube-system
```

Check controller pods:

```bash
kubectl get pods \
  -n kube-system \
  -l app.kubernetes.io/name=aws-load-balancer-controller
```

---

# 17. Metrics Server

Metrics Server provides CPU and memory metrics to Kubernetes.

Check Metrics Server:

```bash
kubectl get deployment \
  metrics-server \
  -n kube-system
```

Check metrics:

```bash
kubectl top nodes
```

Check pod metrics:

```bash
kubectl top pods \
  -n streamingapp
```

---

# 18. EBS CSI Driver

AWS EBS CSI Driver is used for persistent MongoDB storage.

Check addon:

```bash
aws eks describe-addon \
  --cluster-name streamingapp-eks \
  --addon-name aws-ebs-csi-driver \
  --region ap-south-1
```

---

# 19. Helm Deployment

Helm chart:

```text
helm/streamingapp/
```

Check chart:

```bash
helm lint helm/streamingapp
```

Render Kubernetes manifests:

```bash
helm template streamingapp \
  helm/streamingapp \
  -n streamingapp
```

Install:

```bash
helm install streamingapp \
  helm/streamingapp \
  -n streamingapp \
  --create-namespace
```

Upgrade:

```bash
helm upgrade streamingapp \
  helm/streamingapp \
  -n streamingapp \
  -f helm/streamingapp/values.yaml
```

Recommended install/upgrade command:

```bash
helm upgrade --install streamingapp \
  helm/streamingapp \
  -n streamingapp \
  --create-namespace \
  -f helm/streamingapp/values.yaml
```

Check Helm release:

```bash
helm list \
  -n streamingapp
```

Check release status:

```bash
helm status streamingapp \
  -n streamingapp
```

Check history:

```bash
helm history streamingapp \
  -n streamingapp
```

---

# 20. Kubernetes Namespace

Create namespace:

```bash
kubectl create namespace streamingapp
```

Check namespace:

```bash
kubectl get namespace streamingapp
```

---

# 21. Kubernetes Pods

Check pods:

```bash
kubectl get pods \
  -n streamingapp
```

Watch pods:

```bash
kubectl get pods \
  -n streamingapp \
  -w
```

Check pods with node placement:

```bash
kubectl get pods \
  -n streamingapp \
  -o wide
```

Check all resources:

```bash
kubectl get all \
  -n streamingapp
```

---

# 22. Kubernetes Deployments

Check deployments:

```bash
kubectl get deployments \
  -n streamingapp
```

Check rollout:

```bash
kubectl rollout status \
  deployment/frontend \
  -n streamingapp
```

Check deployment details:

```bash
kubectl describe deployment \
  frontend \
  -n streamingapp
```

---

# 23. Kubernetes Services

Check services:

```bash
kubectl get svc \
  -n streamingapp
```

Detailed services:

```bash
kubectl describe svc \
  frontend \
  -n streamingapp
```

Expected services:

```text
frontend
auth-service
streaming-service
admin-service
chat-service
streamingapp-mongo
```

---

# 24. Application Load Balancer

Check Ingress:

```bash
kubectl get ingress \
  -n streamingapp
```

Detailed Ingress:

```bash
kubectl describe ingress \
  streamingapp \
  -n streamingapp
```

Get ALB address:

```bash
kubectl get ingress \
  streamingapp \
  -n streamingapp \
  -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```

Store ALB address:

```bash
ALB=$(kubectl get ingress \
  streamingapp \
  -n streamingapp \
  -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

echo $ALB
```

---

# 25. ALB Routing

The ALB routes traffic according to the following paths:

```text
/                  -> Frontend
/api               -> Auth
/api/streaming     -> Streaming
/api/admin         -> Admin
/api/chat          -> Chat
/socket.io         -> Chat
```

Test frontend:

```bash
curl -I http://$ALB/
```

Test streaming:

```bash
curl -i http://$ALB/api/streaming/videos
```

Test admin:

```bash
curl -i http://$ALB/api/admin/videos
```

Test chat:

```bash
curl -i http://$ALB/api/chat/history/test
```

---

# 26. Expected Validation Results

Frontend:

```text
HTTP/1.1 200 OK
```

Streaming:

```text
HTTP/1.1 200 OK
```

Example:

```json
{
  "success": true,
  "videos": []
}
```

Admin without authentication:

```text
HTTP/1.1 401 Unauthorized
```

Chat without authentication:

```text
HTTP/1.1 401 Unauthorized
```

The 401 responses are expected because these endpoints require authentication.

---

# 27. MongoDB Persistent Storage

MongoDB uses Kubernetes persistent storage backed by AWS EBS.

Storage size:

```text
5 GiB
```

Access mode:

```text
ReadWriteOnce
```

MongoDB replica:

```text
1
```

Check PVC:

```bash
kubectl get pvc \
  -n streamingapp
```

Check PV:

```bash
kubectl get pv
```

Describe PVC:

```bash
kubectl describe pvc \
  streamingapp-mongo \
  -n streamingapp
```

Check MongoDB:

```bash
kubectl get pod \
  -n streamingapp \
  -l component=mongo
```

---

# 28. Important MongoDB Warning

Do not delete the MongoDB PVC unless intentionally destroying the database.

Check PVC before making changes:

```bash
kubectl get pvc \
  -n streamingapp
```

The PVC provides persistence beyond MongoDB pod restarts.

---

# 29. Horizontal Pod Autoscaling

HPA is configured for:

```text
Frontend
Auth
Streaming
Admin
Chat
```

Configuration:

```text
Minimum replicas: 2
Maximum replicas: 3
CPU target: 70%
```

Check HPA:

```bash
kubectl get hpa \
  -n streamingapp
```

Detailed HPA:

```bash
kubectl describe hpa \
  -n streamingapp
```

Check metrics:

```bash
kubectl top pods \
  -n streamingapp
```

Check nodes:

```bash
kubectl top nodes
```

---

# 30. HPA Behavior

Scale up:

```text
CPU utilization > 70%
```

Maximum:

```text
3 replicas
```

Scale down:

```text
After sustained lower utilization
```

MongoDB:

```text
Not autoscaled
```

---

# 31. Kubernetes Resource Requests and Limits

Backend services:

```yaml
resources:
  requests:
    cpu: "100m"
    memory: "128Mi"
  limits:
    cpu: "500m"
    memory: "512Mi"
```

Frontend:

```yaml
resources:
  requests:
    cpu: "50m"
    memory: "64Mi"
  limits:
    cpu: "250m"
    memory: "256Mi"
```

These settings allow Kubernetes to calculate resource utilization for HPA.

---

# 32. Frontend Configuration

The frontend uses same-origin paths.

```text
REACT_APP_AUTH_API_URL=/api

REACT_APP_STREAMING_API_URL=/api

REACT_APP_STREAMING_PUBLIC_URL=

REACT_APP_ADMIN_API_URL=/api/admin

REACT_APP_CHAT_API_URL=/api/chat

REACT_APP_CHAT_SOCKET_URL=/
```

This prevents the browser from attempting to access backend services through localhost after deployment.

---

# 33. Internal Service Health Tests

Auth:

```bash
kubectl exec -n streamingapp \
  deploy/frontend \
  -- wget -qO- http://auth-service:3001/health
```

Streaming:

```bash
kubectl exec -n streamingapp \
  deploy/frontend \
  -- wget -qO- http://streaming-service:3002/api/health
```

Admin:

```bash
kubectl exec -n streamingapp \
  deploy/frontend \
  -- wget -qO- http://admin-service:3003/api/health
```

Chat:

```bash
kubectl exec -n streamingapp \
  deploy/frontend \
  -- wget -qO- http://chat-service:3004/api/health
```

---

# 34. Logs

Frontend logs:

```bash
kubectl logs \
  -n streamingapp \
  deployment/frontend
```

Auth logs:

```bash
kubectl logs \
  -n streamingapp \
  deployment/auth-service
```

Streaming logs:

```bash
kubectl logs \
  -n streamingapp \
  deployment/streaming-service
```

Admin logs:

```bash
kubectl logs \
  -n streamingapp \
  deployment/admin-service
```

Chat logs:

```bash
kubectl logs \
  -n streamingapp \
  deployment/chat-service
```

MongoDB logs:

```bash
kubectl logs \
  -n streamingapp \
  deployment/streamingapp-mongo
```

---

# 35. Troubleshooting

## Pod Not Running

Check:

```bash
kubectl get pods \
  -n streamingapp
```

Describe:

```bash
kubectl describe pod \
  <POD_NAME> \
  -n streamingapp
```

Check logs:

```bash
kubectl logs \
  <POD_NAME> \
  -n streamingapp
```

---

## ImagePullBackOff

Check:

```bash
kubectl describe pod \
  <POD_NAME> \
  -n streamingapp
```

Verify ECR image:

```bash
aws ecr describe-images \
  --repository-name streamingapp-frontend \
  --region ap-south-1
```

Verify AWS identity:

```bash
aws sts get-caller-identity
```

---

## HPA Shows Unknown

Check Metrics Server:

```bash
kubectl get deployment \
  metrics-server \
  -n kube-system
```

Check metrics:

```bash
kubectl top pods \
  -n streamingapp
```

Check HPA:

```bash
kubectl describe hpa \
  -n streamingapp
```

Check resource requests:

```bash
kubectl get deployment \
  -n streamingapp \
  -o yaml
```

---

## ALB Not Available

Check Ingress:

```bash
kubectl get ingress \
  -n streamingapp
```

Describe:

```bash
kubectl describe ingress \
  streamingapp \
  -n streamingapp
```

Check controller:

```bash
kubectl get pods \
  -n kube-system \
  -l app.kubernetes.io/name=aws-load-balancer-controller
```

Check controller logs:

```bash
kubectl logs \
  -n kube-system \
  deployment/aws-load-balancer-controller
```

---

## Service Not Responding

Check service:

```bash
kubectl get svc \
  -n streamingapp
```

Check endpoints:

```bash
kubectl get endpoints \
  -n streamingapp
```

Check endpointslices:

```bash
kubectl get endpointslices \
  -n streamingapp
```

---

# 36. Helm Troubleshooting

Check chart:

```bash
helm lint \
  helm/streamingapp
```

Render manifests:

```bash
helm template streamingapp \
  helm/streamingapp \
  -n streamingapp
```

Check release:

```bash
helm status streamingapp \
  -n streamingapp
```

Check history:

```bash
helm history streamingapp \
  -n streamingapp
```

Rollback if required:

```bash
helm rollback streamingapp \
  <REVISION> \
  -n streamingapp
```

---

# 37. Useful Cluster Commands

Get all resources:

```bash
kubectl get all \
  -n streamingapp
```

Get events:

```bash
kubectl get events \
  -n streamingapp \
  --sort-by=.lastTimestamp
```

Check nodes:

```bash
kubectl get nodes -o wide
```

Check resource usage:

```bash
kubectl top nodes
kubectl top pods -n streamingapp
```

Check namespaces:

```bash
kubectl get namespaces
```

---

# 38. Deployment Verification

Run the following commands after deployment:

```bash
kubectl get nodes
```

```bash
kubectl get pods -n streamingapp
```

```bash
kubectl get svc -n streamingapp
```

```bash
kubectl get ingress -n streamingapp
```

```bash
kubectl get hpa -n streamingapp
```

```bash
helm list -n streamingapp
```

```bash
kubectl top pods -n streamingapp
```

```bash
kubectl top nodes
```

---

# 39. Final Application Validation

Get ALB:

```bash
ALB=$(kubectl get ingress \
  streamingapp \
  -n streamingapp \
  -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

echo "ALB: http://$ALB"
```

Frontend:

```bash
curl -I http://$ALB/
```

Streaming:

```bash
curl -i http://$ALB/api/streaming/videos
```

Admin:

```bash
curl -i http://$ALB/api/admin/videos
```

Chat:

```bash
curl -i http://$ALB/api/chat/history/test
```

---

# 40. Expected Kubernetes State

The expected application state is:

```text
Frontend       2 Running
Auth           2 Running
Streaming      2 Running
Admin          2 Running
Chat           2 Running
MongoDB        1 Running
```

The EKS cluster uses:

```text
3 × t3.small
```

The HPA allows application services to scale:

```text
2 -> 3 replicas
```

---

# 41. Security

Do not commit AWS credentials to GitHub.

Never commit:

```text
AWS Access Key
AWS Secret Access Key
JWT secrets
Database passwords
Jenkins credentials
API keys
```

Check Git status:

```bash
git status
```

Check for accidentally tracked environment files:

```bash
git ls-files | grep -E '(^|/)\.env($|\.)'
```

---

# 42. Git Workflow

Check status:

```bash
git status
```

Pull latest changes:

```bash
git pull origin main
```

Add changes:

```bash
git add .
```

Commit:

```bash
git commit -m "Update project documentation"
```

Push:

```bash
git push origin main
```

Check remote:

```bash
git remote -v
```

Check branch:

```bash
git branch
```

---

# 43. Complete Deployment Workflow

The complete deployment workflow is:

```text
1. Developer pushes code
             |
             v
2. GitHub main branch
             |
             v
3. GitHub webhook
             |
             v
4. Jenkins pipeline
             |
             v
5. Docker image build
             |
             v
6. Push images to ECR
             |
             v
7. Helm deployment
             |
             v
8. EKS pulls images
             |
             v
9. Kubernetes starts pods
             |
             v
10. ALB exposes application
             |
             v
11. Metrics Server collects metrics
             |
             v
12. HPA scales application pods
```

---

# 44. Project Validation Summary

The following components have been implemented:

| Requirement                  | Status    |
| ---------------------------- | --------- |
| MERN Application             | Completed |
| Docker Containerization      | Completed |
| Frontend Dockerfile          | Completed |
| Backend Dockerfiles          | Completed |
| Amazon ECR                   | Completed |
| AWS CLI                      | Completed |
| Jenkins CI/CD                | Completed |
| GitHub Webhook               | Completed |
| Amazon EKS                   | Completed |
| Managed Node Group           | Completed |
| Helm                         | Completed |
| AWS Load Balancer Controller | Completed |
| Application Load Balancer    | Completed |
| Kubernetes Services          | Completed |
| MongoDB                      | Completed |
| AWS EBS Persistence          | Completed |
| Metrics Server               | Completed |
| Horizontal Pod Autoscaling   | Completed |
| Resource Requests/Limits     | Completed |
| External API Validation      | Completed |
| Deployment Documentation     | Completed |

---

# 45. Important Project Details

```text
AWS Region:
ap-south-1

AWS Account:
075237969193

EKS Cluster:
streamingapp-eks

Node Group:
streamingapp-ng

Instance:
t3.small

Kubernetes:
1.33

Namespace:
streamingapp

Helm Release:
streamingapp

ECR Registry:
075237969193.dkr.ecr.ap-south-1.amazonaws.com

Latest Application Image:
build-4

MongoDB Storage:
5 GiB

Application HPA:
2-3 replicas

CPU Target:
70%
```

---

# 46. Documentation Files

Additional documentation:

```text
docs/DEPLOYMENT_DOCUMENTATION.md
docs/FINAL_SUBMISSION_CHECKLIST.md
docs/evidence/final-validation.txt
```

These documents provide additional deployment details and submission evidence.

---

# 47. Final Result

The StreamingApp has been containerized and deployed as a Kubernetes-based application on Amazon EKS.

The project demonstrates:

* Docker containerization
* Microservice deployment
* Amazon ECR
* Jenkins CI/CD
* GitHub webhook automation
* Amazon EKS
* Helm
* AWS Application Load Balancer
* Kubernetes service discovery
* Persistent MongoDB storage
* AWS EBS
* Kubernetes Metrics Server
* Horizontal Pod Autoscaling
* CPU/memory resource management
* Application/API validation
* Deployment documentation

The application is accessible externally through the AWS Application Load Balancer and backend services are routed using Kubernetes Ingress/ALB path-based routing.

````

### Then update and push it

Since you don't want to use `EOF`, use this Python method:

```bash
cd /mnt/c/Users/mithu/StreamingApp

python3 - <<'PY'
from pathlib import Path

# Paste the README content from above between the triple quotes.
# If you save the content into a temporary file instead, simply copy it to README.md.

print("Use the README content above to replace README.md")
PY
````

**Easier and safer:** because the README is very long, I recommend using your editor instead of pasting another huge heredoc:

```bash
cd /mnt/c/Users/mithu/StreamingApp
nano README.md
```

Delete the existing content, paste the complete README above, then:

* `Ctrl + O`
* `Enter`
* `Ctrl + X`

Then run:

```bash
git add README.md
git commit -m "Complete project README documentation"
git push origin main
git status
```

You should finish with:

```text
Your branch is up to date with 'origin/main'.

nothing to commit, working tree clean
```

**One important correction:** don't include real AWS access keys, secret keys, JWT secrets, or passwords anywhere in this README.
