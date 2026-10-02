# StreamingApp – AWS EKS Orchestration and Scaling

## 1. Project Overview

StreamingApp is a MERN-based streaming application deployed on AWS using containerization, Amazon ECR, Jenkins CI/CD, Amazon EKS, Helm, Kubernetes Services, AWS Application Load Balancer and Horizontal Pod Autoscaling.

## 2. Architecture

GitHub
  |
  v
Jenkins CI
  |
  v
Docker Build
  |
  v
Amazon ECR
  |
  v
Amazon EKS
  |
  +-- AWS Application Load Balancer
  |
  +-- Frontend
  |     +-- 2 replicas
  |
  +-- Auth Service
  |     +-- 2 replicas
  |
  +-- Streaming Service
  |     +-- 2 replicas
  |
  +-- Admin Service
  |     +-- 2 replicas
  |
  +-- Chat Service
  |     +-- 2 replicas
  |
  +-- MongoDB
        +-- Persistent EBS volume

## 3. AWS Region

Region:

ap-south-1

AWS Account:

075237969193

## 4. Amazon ECR

The following ECR repositories were created:

- streamingapp-frontend
- streamingapp-auth
- streamingapp-streaming
- streamingapp-admin
- streamingapp-chat

The latest deployed application image version is:

build-4

## 5. Jenkins CI/CD

Jenkins automatically performs:

1. Git checkout
2. AWS credential validation
3. AWS ECR authentication
4. Docker image build
5. Docker image tagging
6. Docker image push to ECR

Images are tagged using:

build-${BUILD_NUMBER}

GitHub webhook integration triggers the Jenkins pipeline after repository changes.

## 6. Kubernetes / EKS

EKS cluster:

streamingapp-eks

Kubernetes version:

1.33

Managed node group:

streamingapp-ng

Node type:

t3.small

Current nodes:

3

Each node provides 2 vCPU and approximately 1.9 GiB capacity.

## 7. Helm

The application is deployed using Helm.

Release:

streamingapp

Namespace:

streamingapp

Current Helm release revision:

12

## 8. Kubernetes Services

| Service | Port |
|---|---:|
| frontend | 80 |
| auth-service | 3001 |
| streaming-service | 3002 |
| admin-service | 3003 |
| chat-service | 3004 |
| streamingapp-mongo | 27017 |

All application services use ClusterIP internally.

## 9. Application Routing

AWS ALB routes traffic as follows:

| Path | Service |
|---|---|
| / | Frontend |
| /api | Auth |
| /api/streaming | Streaming |
| /api/admin | Admin |
| /api/chat | Chat |
| /socket.io | Chat |

## 10. MongoDB Persistence

MongoDB runs as a single replica.

Persistent storage:

- Kubernetes PVC
- AWS EBS
- 5 GiB storage
- ReadWriteOnce

MongoDB is intentionally kept at one replica because it is the stateful database component.

## 11. Horizontal Pod Autoscaling

HPA is configured for:

- Frontend
- Auth
- Streaming
- Admin
- Chat

Configuration:

- Minimum replicas: 2
- Maximum replicas: 3
- CPU target: 70%

Metrics Server provides CPU metrics to Kubernetes HPA.

## 12. Current Application Replicas

The application currently runs:

- Frontend: 2
- Auth: 2
- Streaming: 2
- Admin: 2
- Chat: 2
- MongoDB: 1

## 13. Validation

### Frontend

The frontend was successfully accessed through the AWS ALB and returned:

HTTP 200 OK

### Streaming

The following endpoint was successfully tested:

GET /api/streaming/videos

Result:

HTTP 200 OK

Response:

{"success":true,"videos":[]}

### Admin

GET /api/admin/videos

Result:

HTTP 401 Unauthorized

This confirms that the request reached the Admin service and authentication middleware was executed.

### Chat

GET /api/chat/history/test

Result:

HTTP 401 Unauthorized

This confirms that the request reached the Chat service and authentication middleware was executed.

## 14. CI/CD Validation

Jenkins pipeline completed successfully.

Latest deployed image:

build-4

All five application images were pushed to Amazon ECR and deployed to EKS.

## 15. Final Kubernetes Status

At final validation:

- EKS nodes: Ready
- Application pods: Running
- MongoDB pod: Running
- ALB: Available
- Helm release: Deployed
- HPA: Configured
- Metrics Server: Working

## 16. Useful Commands

### Check nodes

kubectl get nodes

### Check application pods

kubectl get pods -n streamingapp

### Check services

kubectl get svc -n streamingapp

### Check ingress

kubectl get ingress -n streamingapp

### Check HPA

kubectl get hpa -n streamingapp

### Check Helm release

helm list -n streamingapp

### Check resource metrics

kubectl top pods -n streamingapp

## 17. Conclusion

StreamingApp was successfully containerized and deployed to Amazon EKS using Helm. Jenkins provides automated CI builds and pushes Docker images to Amazon ECR. AWS Application Load Balancer provides external access and routes requests to the appropriate Kubernetes services. MongoDB uses persistent AWS EBS storage. Horizontal Pod Autoscaling is configured for the stateless application services with CPU-based scaling.

The application was externally validated through the ALB and the main application routes responded successfully.
