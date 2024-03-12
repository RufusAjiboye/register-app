pipeline {
    agent any
    tools {
        jdk 'Java17'
        maven 'Maven3'
    }
    environment {
        APP_NAME = "register-app-job"
        RELEASE = "1.0.0"
        DOCKER_USER = "02271589"
        DOCKER_PASS = "dockerhub"
        IMAGE_NAME = "${DOCKER_USER}" + "/" + "${APP_NAME}"
        IMAGE_TAG = "${RELEASE}-${BUILD_NUMER}"
        JENKINS_API_TOKEN = credentials("JENKINS_API_TOKEN")
    }

    stages {
        stage('Cleanup Workspace') {
            steps{
                cleanWs()
            }
        }

        stage('Checkout from SCM') {
            steps{
                git branch: 'main', credentialsId: 'github', url: 'https://github.com/SoftwareDevDeveloper/register-app'
            }
        }

        stage('Build Application') {
            steps{
                sh "mvn clean package"
            }
        }

        stage('Test Application') {
            steps{
                sh "mvn test"
            }
        }
        
        //Sonarqube will scan the code for vulnerabilities and bugs
        stage('Sonarqube Analysis') {
            steps{
                script {
                    withSonarQubeEnv(credentialsId: 'jenkins-sonarqube-token') {
                    sh "mvn sonar:sonar"
                    }
                }
            }
        }

        stage('Quality Gate') {
            steps{
                script{
                    waitForQualityGate abortPipeline: false, credentialsId: 'jenkins-sonarqube-token'
                }
            }
        }

        stage('Build and Push Docker Image') {
            steps{
                script {
                    docker.withRegistry('',DOCKER_PASS) {
                        docker_image = docker.build "${IMAGE_NAME}"
                    }

                    docker.withRegistry('',DOCKER_PASS) {
                        docker_image.push("${IMAGE_TAG}")
                        docker_image.push('latest')
                    }
                }
            }
        }

        stage('Run Docker Image') {
            steps {
                sh "docker run -d -p 73:80 02271589/register-app-job:latest"
            }
        }


        //Trivy will Scan the Docker Image
        stage('Trivy Scan') {
            steps{
                scripts {
                    sh ('docker run -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image 02271589/register-app-job:latest --no-progress --scanners vuln  --exit-code 0 --severity HIGH,CRITICAL --format table')
                }
            }
        }

        stage('Cleanup Artifacts') {
            steps {
                script {
                   // sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker rmi ${IMAGE_NAME}:latest"
                }
            }
        }

        stage('Trigger CD Pipeline') {
            steps {
                script {
                     sh "curl -v -k --user Admin:${JENKINS_API_TOKEN} -X POST -H 'cache-control: no-cache' -H 'content-type: application/x-www-form-urlencoded' --data 'IMAGE_TAG=${IMAGE_TAG}' 'ec2-3-253-129-55.eu-west-1.compute.amazonaws.com:8080/job/gitops-Register-APP-CI/buildWithParameters?token=gitops-token'"
                }
            }
        } 
    }
}