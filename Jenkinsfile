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


git changelog: false, poll: false, url: 'https://github.com/syafarul/VNT_mesinkasirr.git'

withDockerRegistry(credentialsId: 'docker_kasirVNT', toolName: 'Docker') {

}
