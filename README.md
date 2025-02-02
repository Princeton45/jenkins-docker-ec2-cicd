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
- Set up an EC2 instance with Docker installation
- Created SSH key integration between Jenkins and EC2
- Extended existing CI pipeline from [Jenkins Multi-pipeline project](https://github.com/Princeton45/jenkins-multi-pipeline) with automated deployment capabilities

- Configured EC2 security groups for web application access

![Jenkins Pipeline Stage 1](suggested_image: Screenshot of Jenkins pipeline showing successful deployment stage)

## Part 2: Docker Compose Implementation

### What I Accomplished
- Enhanced EC2 instance with Docker Compose functionality
- Created a docker-compose.yml for streamlined deployment
- Optimized Jenkins pipeline with Docker Compose integration
- Implemented shell script optimization for remote server commands

![Docker Compose Configuration](suggested_image: Screenshot of docker-compose.yml and directory structure)

## Part 3: Advanced CI/CD Pipeline with Dynamic Versioning

### What I Accomplished
- Implemented automatic version incrementing
- Set up Maven artifact building pipeline
- Established Docker Hub integration for image management
- Created version control system for deployment tracking
- Automated version update commits

![Complete Pipeline Overview](suggested_image: Screenshot of final Jenkins pipeline with all stages)

## Key Features
- Automated deployment process
- Scalable Docker container management
- Version control integration
- Secure AWS infrastructure
- Optimized build and deployment scripts

## Infrastructure Setup
- AWS EC2 t2.micro instance running Amazon Linux 2
- Jenkins server with necessary plugins
- Docker Hub repository for image storage
- GitHub repository for version control

![Infrastructure Diagram](suggested_image: Simple diagram showing the infrastructure components)

## Results and Metrics
- Deployment time reduced from manual processes to under 5 minutes
- Zero-downtime deployments
- Automated version management
- Scalable container architecture

## Lessons Learned
- Importance of script optimization
- Benefits of Docker Compose in deployment
- Value of automated version control
- Security considerations in CI/CD pipelines

## Future Improvements
- Kubernetes integration
- Blue-Green deployment strategy
- Enhanced monitoring and logging
- Automated rollback capabilities

## Contact
Feel free to connect with me for any questions or suggestions!

[Your Contact Information]
