pipeline {
    agent any

    environment {
        DOCKER_COMPOSE_FILE = 'docker-compose.yml'
    }

    stages {
        // Stage 1: Checkout the code
        stage('Checkout Code') {
            steps {
                // Mengambil kode dari repository
                checkout scm
            }
        }

        // Stage 2: Build Docker Images
        stage('Build Docker Images') {
            steps {
                // Membangun image Docker menggunakan docker-compose
                script {
                    sh 'docker-compose -f ${DOCKER_COMPOSE_FILE} build'
                }
            }
        }

        // Stage 3: Start Docker Containers
        stage('Start Docker Containers') {
            steps {
                // Menjalankan Docker Compose untuk memulai layanan
                script {
                    sh 'docker-compose -f ${DOCKER_COMPOSE_FILE} up -d'
                }
            }
        }

        // Stage 4: Run Tests
        stage('Run Tests') {
            steps {
                // Contoh menjalankan tes, sesuaikan dengan kebutuhan aplikasi Anda
                script {
                    // Gantilah perintah ini dengan perintah tes Anda
                    sh 'docker exec kasir_vnt_app php artisan test'
                }
            }
        }

        // Stage 5: Cleanup Docker Containers
        stage('Cleanup') {
            steps {
                // Menurunkan dan menghapus container setelah tes selesai
                script {
                    sh 'docker-compose -f ${DOCKER_COMPOSE_FILE} down'
                }
            }
        }
    }

    post {
        always {
            // Menjaga container tetap bersih, membersihkan jika terjadi kesalahan
            echo 'Cleaning up after build...'
            sh 'docker-compose -f ${DOCKER_COMPOSE_FILE} down'
        }
    }
}
