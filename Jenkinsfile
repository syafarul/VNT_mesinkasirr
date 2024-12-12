pipeline {
    agent any
    environment {
        // Definisikan variabel environment yang diperlukan
        DOCKER_COMPOSE = 'docker-compose'
        IMAGE_NAME = 'kasir_vnt_app'
        CONTAINER_NAME = 'kasir_vnt_app'
        PHP_IMAGE = 'php:7.4-fpm' // Ganti sesuai dengan versi PHP yang Anda pakai
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout kode dari repository
                checkout scm
            }
        }

        stage('Build Docker Images') {
            steps {
                script {
                    // Build Docker Image untuk aplikasi
                    sh 'docker-compose -f docker-compose.yml build'
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    // Jalankan tes Laravel, misalnya menggunakan PHPUnit
                    sh 'docker-compose run --rm app ./vendor/bin/phpunit'
                }
            }
        }

        stage('Build Frontend (Optional)') {
            steps {
                script {
                    // Build frontend jika diperlukan (misalnya, menggunakan npm/yarn)
                    sh 'docker-compose run --rm app npm install'
                    sh 'docker-compose run --rm app npm run prod'
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // Deployment aplikasi ke server atau environment
                    // Contoh dengan docker-compose up untuk menjalankan container
                    sh 'docker-compose -f docker-compose.yml up -d'
                }
            }
        }

        stage('Post-Deploy Checks') {
            steps {
                script {
                    // Post-deployment: Misalnya, verifikasi aplikasi berjalan dengan baik
                    sh 'docker-compose ps'
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline Succeeded!'
        }
        failure {
            echo 'Pipeline Failed!'
        }
    }
}
