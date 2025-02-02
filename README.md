# Complete CI/CD Pipeline with Jenkins, Docker, and AWS EC2

## Project Overview
I created a comprehensive CI/CD pipeline that demonstrates the deployment strategies using Jenkins, Docker, and AWS EC2. The project is divided into three progressive stages, each building upon the previous one.

## CI/CD Pipeline Flow

The pipeline automates the entire process from code commit to deployment:

**CI Process:**
- Developer pushes code → GitHub webhook triggers Jenkins
- Jenkins increments version and updates pom.xml
- Maven builds and tests Java application
- Docker image built and pushed to Docker Hub

**CD Process:**
- Jenkins pulls latest image and connects to EC2
- Deploys application via Docker Compose on EC2
- Updates version control and verifies deployment

![diagram](https://github.com/Princeton45/jenkins-docker-ec2-cicd/blob/main/images/diagram.png)

Triggers: Git push to main branch or manual Jenkins trigger

## Technologies Used
- AWS EC2
- Jenkins
- Docker & Docker Compose
- Git
- Java
- Maven
- Docker Hub
- Linux

## Part 1: Basic Docker Deployment Pipeline

### What I Accomplished
- I set up an EC2 instance with Docker installed

![ec2](https://github.com/Princeton45/jenkins-docker-ec2-cicd/blob/main/images/ec2-instance.png)

- Installed `SSH Agent` plugin on Jenkins & setup SSH key integration between Jenkins and EC2

![ssh-agent](https://github.com/Princeton45/jenkins-docker-ec2-cicd/blob/main/images/ssh-agent.png)

- Added my ec2 instance ssh private key as a credential in Jenkins

![key](https://github.com/Princeton45/jenkins-docker-ec2-cicd/blob/main/images/key.png)



- Extended existing CI Jenkins pipeline from [Jenkins Multi-pipeline project](https://github.com/Princeton45/jenkins-multi-pipeline) to connect to EC2 and run Docker command.

```groovy
stage("deploy") {
            steps {
                script {
                    def dockerCmd = "docker run -p 3080:3080 -d ${IMAGE_NAME}"
                    sshagent(['ec2-server-key']) {
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@35.174.114.33 ${dockerCmd}"
                    }
                }
            }
```


- Edited EC2 Security Group to give Jenkins permission to access the EC2

![jenkins-ip](https://github.com/Princeton45/jenkins-docker-ec2-cicd/blob/main/images/jenkins-ip2.png)

`67.205.164.34` is the IP of the Jenkins server

Successful pipeline run:

![success](https://github.com/Princeton45/jenkins-docker-ec2-cicd/blob/main/images/success.png)


## Part 2: Docker Compose Implementation

### What I Accomplished
- Enhanced EC2 instance with Docker Compose functionality

- Installed Docker Compose on the EC2 instance

```bash
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
```

Then change the permissions for the docker-compose bin

`sudo chmod +x /usr/local/bin/docker-compose`

- Created a docker-compose.yml for streamlined deployment

```yaml
FROM amazoncorretto:8-alpine3.17-jre

EXPOSE 8080

COPY ./target/java-maven-app-*.jar /usr/app/
WORKDIR /usr/app

ENTRYPOINT java -jar $(ls java-maven-app-*.jar)
```

- Optimized Deploy step in Jenkins pipeline with Docker Compose integration

```groovy
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
```

- Implemented shell script optimization for remote server commands

This is so that we can pass in additional commands needed before starting up the containers in the `docker-compose` file (things like changing permissions in directories, creating directories, network commands, etc).

In this case, I just exported the `$IMAGE_NAME` so the docker-compose.yaml is aware of the variable, ran the docker-compose command and ran an echo success message.

`server-cmds.sh`

```bash
#!/usr/bin/env bash

export IMAGE_NAME=$1
docker-compose -f docker-compose.yaml up -d
echo "success"
```

## Part 3: Advanced CI/CD Pipeline with Dynamic Versioning

### What I Accomplished
- Implemented automatic version incrementing
- Set up Maven artifact building pipeline
- Established Docker Hub integration for image management
- Created version control system for deployment tracking
- Automated version update commits

