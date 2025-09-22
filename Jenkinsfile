pipeline {
    agent none

    environment {
        DOCKER_HUB = 'bassemosama12'
        IMAGE_NAME = 'java-app'
        GIT_REPO = 'https://github.com/bassemosama/java-app.git'
    }

    stages {
        stage('Build on Container Agent') {
            agent { label 'container-agent' }

            steps {
                git url: "${env.GIT_REPO}", credentialsId: 'github'

                script {
                    // Build Docker image
                    sh "docker build -t ${DOCKER_HUB}/${IMAGE_NAME}:latest ."
                    
                    // Login to Docker Hub
                    withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    }

                    // Push Docker image
                    sh "docker push ${DOCKER_HUB}/${IMAGE_NAME}:latest"
                }
            }
        }

        stage('Deploy on Instance Agent') {
            agent { label 'instance-agent' }

            steps {
                git url: "${env.GIT_REPO}", credentialsId: 'github'

                script {
                    // Pull image from Docker Hub
                    sh "docker pull ${DOCKER_HUB}/${IMAGE_NAME}:latest"

                    // Run container
                    sh "docker run --rm ${DOCKER_HUB}/${IMAGE_NAME}:latest"
                }
            }
        }
    }
}
