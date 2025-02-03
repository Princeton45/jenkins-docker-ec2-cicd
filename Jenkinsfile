#!/usr/bin/env groovy

pipeline {
    agent any
    tools {
        maven 'maven-3.9'
    }
    stages {
        stage("increment version") {
            steps {
                script {
                    echo "incrementing app version..."
                    sh 'mvn build-helper:parse-version versions:set \
                        -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.minorVersion}.\\\${parsedVersion.nextIncrementalVersion} \
                        versions:commit'
                    def matcher = readFile('pom.xml') =~ '<version>(.+)</version>'
                    def version = matcher[0][1]
                    env.IMAGE_NAME = "prince450/demo-app:${version}-${BUILD_NUMBER}"
                }
            }
        }
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
                    def shellCmd = "IMAGE_NAME=${IMAGE_NAME} bash ./server-cmds.sh"
                    def ec2Instance = "ec2-user@54.234.189.5"
                    sshagent(['ec2-server-key']) {
                        sh "scp server-cmds.sh ${ec2Instance}:/home/ec2-user"
                        sh "scp docker-compose.yaml ${ec2Instance}:/home/ec2-user"
                        sh "ssh -o StrictHostKeyChecking=no ${ec2Instance} ${shellCmd}"
                    }
                }
            }
        }

        stage("commit version update") {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'github-credentials', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                        // Add git config commands to avoid errors
                        sh 'git config --global user.email "jenkins@example.com"'
                        sh 'git config --global user.name "jenkins"'
                        sh "git remote set-url origin https://${USER}:${PASS}@github.com/Princeton45/jenkins-docker-ec2-cicd.git"
                        sh "git add ."
                        sh 'git commit -m "ci: version bump"'
                        sh "git push origin HEAD:main"
                    }
                }
            }
        }
    }
}