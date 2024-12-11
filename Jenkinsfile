pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'kasir_vnt_app'
        NETWORK_NAME = 'kasir_vnt'
        MYSQL_ROOT_PASSWORD = 'farul123'
        MYSQL_DATABASE = 'vnt_kasir'
        REGISTRY = 'https://index.docker.io/v1/'
    }
    stages {
        stage('Preparation') {
            steps {
                echo 'Checking Docker environment and cleaning up previous resources...'
                script {
                    try {
                        powershell '''
                        echo "Checking if Docker is installed..."
                        if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
                            echo "Docker is not installed"
                            exit 1
                        }

                        echo "Checking if Docker Compose is installed..."
                        if (-not (Get-Command docker-compose -ErrorAction SilentlyContinue)) {
                            echo "Docker Compose is not installed"
                            exit 1
                        }

                        echo "Stopping and cleaning up previous containers..."
                        docker-compose down || Write-Host "No containers to stop."

                        echo "Removing Docker network if exists..."
                        if (docker network ls --filter name=${NETWORK_NAME} -q) {
                            docker network rm ${NETWORK_NAME}
                        } else {
                            echo "Network does not exist, skipping."
                        }
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
                            powershell '''
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
                        powershell '''
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
}
