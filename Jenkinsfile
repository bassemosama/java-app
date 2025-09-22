pipeline {
    agent none

    environment {
        DOCKER_IMAGE = 'bassemosama12/java-app'
    }

    stages {
        stage('Checkout') {
            agent any
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/jenkins-task']],
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [],
                    userRemoteConfigs: [[
                        url: 'https://github.com/bassemosama/java-app.git',
                        credentialsId: 'github'
                    ]]
                ])
            }
        }

        stage('Build & Deploy in Parallel') {
            parallel {
                stage('Build & Push on Container Agent') {
                    agent { label 'container-agent' }
                    steps {
                        script {
                            withCredentials([usernamePassword(
                                credentialsId: 'dockerhub',
                                usernameVariable: 'DOCKER_USER',
                                passwordVariable: 'DOCKER_PASS'
                            )]) {
                                sh 'docker login -u $DOCKER_USER -p $DOCKER_PASS'
                            }

                            sh "docker build -t ${env.DOCKER_IMAGE}:${env.BUILD_NUMBER} ."
                            sh "docker push ${env.DOCKER_IMAGE}:${env.BUILD_NUMBER}"

                            echo "✅ Built and pushed: ${env.DOCKER_IMAGE}:${env.BUILD_NUMBER}"
                        }
                    }
                }

                stage('Deploy on Instance Agent') {
                    agent { label 'ec2-agent' }
                    steps {
                        script {
                            withCredentials([usernamePassword(
                                credentialsId: 'dockerhub',
                                usernameVariable: 'DOCKER_USER',
                                passwordVariable: 'DOCKER_PASS'
                            )]) {
                                sh 'docker login -u $DOCKER_USER -p $DOCKER_PASS'
                            }

                            sh "docker pull ${env.DOCKER_IMAGE}:${env.BUILD_NUMBER}"
                            sh 'docker stop java-app-running || true'
                            sh 'docker rm java-app-running || true'

                            sh """
                                docker run -d \
                                  --name java-app-running \
                                  -p 8080:8080 \
                                  ${env.DOCKER_IMAGE}:${env.BUILD_NUMBER}
                            """

                            echo "✅ Deployed on instance agent using image: ${env.DOCKER_IMAGE}:${env.BUILD_NUMBER}"
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                node('container-agent') {
                    sh 'docker logout || true'
                }
                node('instance-agent') {
                    sh 'docker logout || true'
                }
            }
        }
    }
}