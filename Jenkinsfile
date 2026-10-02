pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-1'
        AWS_ACCOUNT_ID = '075237969193'
        ECR_REGISTRY = '075237969193.dkr.ecr.ap-south-1.amazonaws.com'
        IMAGE_TAG = "build-${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Verify Tools') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'mithun-streamingapp-ecr'
                ]]) {
                    sh '''
                        echo "Checking required tools..."
                        docker --version
                        aws --version
                        aws sts get-caller-identity
                    '''
                }
            }
        }

        stage('ECR Login') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'mithun-streamingapp-ecr'
                ]]) {
                    sh '''
                        aws ecr get-login-password --region ${AWS_REGION} | \
                        docker login \
                        --username AWS \
                        --password-stdin ${ECR_REGISTRY}
                    '''
                }
            }
        }

        stage('Build Docker Images') {
            steps {
                sh '''
                    docker build \
                      --build-arg REACT_APP_AUTH_API_URL=/api \
                      --build-arg REACT_APP_STREAMING_API_URL=/api \
                      --build-arg REACT_APP_STREAMING_PUBLIC_URL= \
                      --build-arg REACT_APP_ADMIN_API_URL=/api/admin \
                      --build-arg REACT_APP_CHAT_API_URL=/api/chat \
                      --build-arg REACT_APP_CHAT_SOCKET_URL=/ \
                      -t ${ECR_REGISTRY}/streamingapp-frontend:${IMAGE_TAG} \
                      ./frontend

                    docker build \
                      -t ${ECR_REGISTRY}/streamingapp-auth:${IMAGE_TAG} \
                      ./backend/authService

                    docker build \
                      -t ${ECR_REGISTRY}/streamingapp-streaming:${IMAGE_TAG} \
                      -f ./backend/streamingService/Dockerfile \
                      ./backend

                    docker build \
                      -t ${ECR_REGISTRY}/streamingapp-admin:${IMAGE_TAG} \
                      -f ./backend/adminService/Dockerfile \
                      ./backend

                    docker build \
                      -t ${ECR_REGISTRY}/streamingapp-chat:${IMAGE_TAG} \
                      -f ./backend/chatService/Dockerfile \
                      ./backend
                '''
            }
        }

        stage('Push Images to ECR') {
            steps {
                sh '''
                    docker push ${ECR_REGISTRY}/streamingapp-frontend:${IMAGE_TAG}
                    docker push ${ECR_REGISTRY}/streamingapp-auth:${IMAGE_TAG}
                    docker push ${ECR_REGISTRY}/streamingapp-streaming:${IMAGE_TAG}
                    docker push ${ECR_REGISTRY}/streamingapp-admin:${IMAGE_TAG}
                    docker push ${ECR_REGISTRY}/streamingapp-chat:${IMAGE_TAG}
                '''
            }
        }

        stage('Deployment Summary') {
            steps {
                echo """
                ==========================================
                StreamingApp CI completed successfully
                ==========================================
                Image Tag: ${IMAGE_TAG}

                Images pushed:
                - streamingapp-frontend
                - streamingapp-auth
                - streamingapp-streaming
                - streamingapp-admin
                - streamingapp-chat
                ==========================================
                """
            }
        }
    }

    post {
        success {
            echo 'StreamingApp CI pipeline completed successfully.'
        }

        failure {
            echo 'StreamingApp CI pipeline failed. Check the console output.'
        }
    }
}
