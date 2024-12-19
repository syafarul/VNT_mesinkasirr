pipeline {
    agent any
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials-id') // ID kredensial DockerHub
        ANSIBLE_SERVER = 'ansible.server.ip' // IP/Hostname server Ansible
        KUBERNETES_SERVER = 'kubernetes.server.ip' // IP/Hostname server Kubernetes
    }
    stages {
        stage('Git Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Send Docker Compose to Ansible Server') {
            steps {
                sh '''
                scp docker-compose.yml ansible@${ANSIBLE_SERVER}:/path/to/docker
                scp -r ./nginx ansible@${ANSIBLE_SERVER}:/path/to/docker
                scp -r ./storage ansible@${ANSIBLE_SERVER}:/path/to/docker
                '''
            }
        }
        stage('Docker Compose Build and Push') {
            steps {
                sh '''
                ssh ansible@${ANSIBLE_SERVER} "
                    cd /path/to/docker &&
                    docker-compose build &&
                    docker login -u ${DOCKERHUB_CREDENTIALS_USR} -p ${DOCKERHUB_CREDENTIALS_PSW} &&
                    docker-compose push
                "
                '''
            }
        }
        stage('Copy Kubernetes Deployment Files') {
            steps {
                sh '''
                scp kubernetes/deployment.yml ansible@${KUBERNETES_SERVER}:/path/to/kubernetes
                '''
            }
        }
        stage('Kubernetes Deployment using Ansible') {
            steps {
                sh '''
                ssh ansible@${KUBERNETES_SERVER} "
                    ansible-playbook /path/to/kubernetes/deploy-kubernetes.yml
                "
                '''
            }
        }
    }
}
