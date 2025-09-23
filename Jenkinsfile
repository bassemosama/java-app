pipeline {
    agent none
    stages {

        stage('Build on Container Agent') {
            agent { label 'container-agent' }
            steps {
                echo "Building app on CONTAINER agent..."
                sh 'mvn clean package'
            }
        }

        stage('Build on EC2 Agent') {
            agent { label 'ec2-agent' }
            steps {
                echo "Building app on EC2 agent..."
                sh 'mvn clean package'
            }
        }

        stage('Deploy on Container Agent') {
            agent { label 'container-agent' }
            steps {
                echo "Deploying app on CONTAINER agent..."
                sh 'java -jar target/*.jar'
            }
        }

        stage('Deploy on EC2 Agent') {
            agent { label 'ec2-agent' }
            steps {
                echo "Deploying app on EC2 agent..."
                sh 'java -jar target/*.jar'
            }
        }
    }
}
