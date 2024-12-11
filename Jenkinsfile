pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'kasir_vnt_app' // Nama image Docker Anda
        NETWORK_NAME = 'kasir_vnt'    // Nama network Docker
        MYSQL_ROOT_PASSWORD = 'farul123' // Password root MySQL
        MYSQL_DATABASE = 'vnt_kasir'  // Nama database MySQL
        REGISTRY = 'https://index.docker.io/v1/' // Registry Docker
    }

    stages {
        stage('Preparation') {
            steps {
                echo 'Checking Docker environment and cleaning up previous resources...'
                script {
                    try {
                        sh '''
                        echo "Checking if Docker is installed..."
                        docker --version || { echo "Docker is not installed"; exit 1; }

                        echo "Checking if Docker Compose is installed..."
                        docker-compose --version || { echo "Docker Compose is not installed"; exit 1; }

                        echo "Stopping and cleaning up previous containers..."
                        docker-compose down || true

                        echo "Removing Docker network if exists..."
                        docker network rm ${NETWORK_NAME} || echo "Network does not exist, skipping."
                        '''
                    } catch (Exception e) {
                        error "Preparation stage failed: ${e.message}"
                    }
                }
            }
        }

        stage('Build Docker Images') {
            steps {
                echo 'Building Docker images...'
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker_kasirVNT', 
                                                      usernameVariable: 'REGISTRY_USERNAME', 
                                                      passwordVariable: 'REGISTRY_PASSWORD')]) {
                        try {
                            sh '''
                            echo "Logging in to Docker registry..."
                            docker login ${REGISTRY} -u $REGISTRY_USERNAME -p $REGISTRY_PASSWORD

                            echo "Building images with Docker Compose..."
                            docker-compose build --no-cache --pull

                            echo "Pushing images to Docker registry..."
                            docker-compose push
                            '''
                        } catch (Exception e) {
                            error "Failed to build and push Docker images: ${e.message}"
                        }
                    }
                }
            }
        }

        stage('Run Containers') {
            steps {
                echo 'Starting containers with Docker Compose...'
                script {
                    try {
                        sh '''
                        echo "Starting containers..."
                        docker-compose up -d
                        '''
                    } catch (Exception e) {
                        error "Failed to start containers: ${e.message}"
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up temporary resources...'
            script {
                sh '''
                echo "Stopping containers..."
                docker-compose down || true

                echo "Removing Docker network..."
                docker network rm ${NETWORK_NAME} || echo "Network does not exist, skipping."
                '''
            }
        }
    }
}
