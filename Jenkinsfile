pipeline {
    agent any
    stages {
        stage("Verify tooling") {
            steps {
                sh '''
                    docker info
                    docker version
                    docker compose version
                '''
            }
        }
        stage("Clear all running docker containers") {
            steps {
                ansiblePlaybook(
                    playbook: 'ansible/clear_containers.yml',
                    inventory: 'ansible/inventory.ini'
                )
            }
        }
        stage("Start Docker Services") {
            steps {
                sh 'make up'
                sh 'docker compose ps'
            }
        }
        stage("Run Composer Install") {
            steps {
                sh 'docker compose run --rm composer install'
            }
        }
        stage("Populate .env file") {
            steps {
                dir("/var/lib/jenkins/workspace/envs/laravel-test") {
                    fileOperations([fileCopyOperation(excludes: '', flattenFiles: true, includes: '.env', targetLocation: "${WORKSPACE}")])
                }
            }
        }
        stage("Run Tests") {
            steps {
                sh 'docker compose run --rm artisan test'
            }
        }
    }
    post {
        success {
            steps {
                script {
                    sh 'cd "/var/lib/jenkins/workspace/LaravelTest"'
                    sh 'rm -rf artifact.zip'
                    sh 'zip -r artifact.zip . -x "node_modules*"'
                }
                ansiblePlaybook(
                    playbook: 'ansible/deploy_application.yml',
                    inventory: 'ansible/inventory.ini',
                    extraVars: [
                        workspace: "${env.WORKSPACE}",
                        artifact: "${env.WORKSPACE}/artifact.zip"
                    ]
                )
            }
        }
        always {
            sh 'docker compose down --remove-orphans -v'
            sh 'docker compose ps'
        }
    }
}
