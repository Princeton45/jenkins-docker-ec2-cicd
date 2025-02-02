#!/usr/bin.env groovy

pipeline {
    agent any
    tools {
        maven 'maven-3.9'
    }
    environment {
        IMAGE_NAME = "prince450/demo-app:java-maven-1.0"
    }
    stages {
        stage('build app') {
            steps {
                echo 'building application jar...'
                sh 'mvn package'
            }
        }
        stage('build image') {
            steps {
                script {
                    echo "building the docker image..."
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-repo', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                        sh "docker build -t ${IMAGE_NAME} ."
                        sh 'echo $PASS | docker login -u $USER --password-stdin'
                        sh "docker push ${IMAGE_NAME}"
                    }
                }
            }
        }

        stage("deploy") {
            steps {
                script {
                    echo "deploying docker image to EC2"

                    def shellCmd = "bash ./server-cmds.sh ${IMAGE_NAME}"

                    sshagent(['ec2-server-key']) {
                        sh "scp server-cmds.sh ec2-user@54.234.189.5:/home/ec2-user"
                        sh "scp docker-compose.yaml ec2-user@54.234.189.5:/home/ec2-user"
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@54.234.189.5 ${shellCmd}"
                    }
                }
            }
        }               
    }
}