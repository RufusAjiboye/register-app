pipeline {
    agent any
    tools {
        jdk 'Java17'
        maven 'Maven3'
    }

    environment {
        APP_NAME = "register-app-pipeline"
        RELEASE = "1.0.0"
        DOCKER_USER = "02271589"
        DOCKER_PASS = "jenkins-dockerhub-token"
        IMAGE_NAME = "${DOCKER_USER}" + "/" + "${APP_NAME}"
        IMAGE_TAG = "${RELEASE}-${BUILD_NUMER}"
        JENKINS_API_TOKEN = credentials("JENKINS_API_TOKEN")
    }

    stages{
        stage("CleanUp Workspace") {
            steps {
                cleanWs()
            }
        }

        stage("Check out from SCM") {
            steps {
                git branch: 'main', credentialsId: 'github', url: 'https://github.com/SoftwareDevDeveloper/register-app'
            }
        }

        stage("Build Application") {
            steps {
                sh "mvn clean package"
            }
        }

        stage("Test Application") {
            steps {
                sh "mvn test"
            }
        }

        stage("Sonarqube Analysis") {
            steps {
                script {
                    withSonarQubeEnv(credentialsId: 'jenkins-sonarqube-token') {
                    sh "mvn sonar:sonar"
                    }
                }
            }
        }

        stage("Quality gate") {
            steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'jenkins-sonarqube-token'
                }
            }
        }

        stage("Build docker Image") {
            steps {
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

        // stage("Build docker Image") {
        //     steps {
        //         script {
        //             withDockerRegistry(credentialsId: 'jenkins-dockerhub-token', toolName: 'docker') {
        //                 sh '''
        //                 sudo docker build -t registerapp .
        //                 sudo docker tag registerapp 02271589/registerapp:latest
        //                 sudo docker push 02271589/registerapp:latest
        //                 '''
        //             }
        //         }
        //     }
        // }

        stage('Run docker Image') {
            steps {
                sh "docker run -d -p 8011:80 02271589/register-app-pipeline:latest"
            }
        }

        // stage('TRIVY FS Scan') {
        //     steps {
        //         sh "trivy fs . > trivyfs.txt"
        //     }
        // }

        stage("Trigger CD Pipeline") {
            steps {
                script {
                    sh "curl -v -k --user Admin:${JENKINS_API_TOKEN} -X POST -H 'cache-control: no-cache' -H 'content-type: application/x-www-form-urlencoded' --data 'IMAGE_TAG=${IMAGE_TAG}' 'ec2-3-252-138-197.eu-west-1.compute.amazonaws.com:8080/job/gitops-register-app-cd/buildWithParameters?token=gitops-token'"

                }
            }
        }
    }
}































// pipeline {
//     agent {label 'jenkins-Agent'}
//     agent any
//     tools {
//         jdk 'Java17'
//         maven 'Maven3'
//     }

//     environment {
//             // ACCCESS_KEY_ID = credentials ('ACCESS_KEY_ID')
//             // SECRET_ACCESS_KEY = credentials('SECRET_ACCESS_KEY')
//             // hub_username = credentials ('DOCKERHUB_USER')
//             // hub_password = credentials ('DOCKERHUB_PASS')

//             APP_NAME = "register-app-pipeline"
//             RELEASE = "1.0.0"
//             DOCKER_USER = "02271589"
//             DOCKER_PASS = 'dockerhub'
//             IMAGE_NAME = "${DOCKER_USER}" + "/" + "${APP_NAME}"
//             IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"
//             JENKINS_API_TOKEN = credentials("JENKINS_API_TOKEN")
//     }

//     stages {
//         stage('Cleanup workspace') {
//             steps {
//                 cleanWs()
//             }
//         }

//         stage('Checkout from SCM') {
//             steps {
//                 git branch: 'main', credentialsId: 'github', url: 'https://github.com/SoftwareDevDeveloper/register-app'
//             }
//         }

//         stage('Build Application') {
//             steps {
//                 sh "mvn clean package"
//             }
//         }

//         stage("Test Application") {
//             steps {
//                 sh "mvn test"
//             }
//         }

//         stage("SonarQube Anlysis") {
//             steps {
//                 script {
//                     withSonarQubeEnv(credentialsId: 'jenkins-sonarqube-token') {
//                     sh "mvn sonar:sonar"
//                     }
//                 }
//             }
//         }

//         stage("Quality Gate") {
//             steps {
//                 script {
//                     waitForQualityGate abortPipeline: false, credentialsId: 'jenkins-sonarqube-token'
//                 }
//             }
//         }

//         stage("Build & Push Docker Image") {
//             steps {
//                 script {
//                     docker.withRegistry('',DOCKER_PASS) {
//                         docker_image = docker.build "${IMAGE_NAME}"
//                     }

//                     docker.withRegistry('',DOCKER_PASS) {
//                         docker_image.push("${IMAGE_TAG}")
//                         docker_image.push('latest')
//                     }
//                 }
//             }
//        }

//         stage("Trigger CD Pipeline") {
//             steps {
//                 script {
//                     sh "curl -v -k --user clouduser:${JENKINS_API_TOKEN} -X POST -H 'cache-control: no-cache' -H 'content-type: application/x-www-form-urlencoded' --data 'IMAGE_TAG=${IMAGE_TAG}' 'ec2-52-213-251-235.eu-west-1.compute.amazonaws.com:8080/job/gitops-register-app-cd/buildWithParameters?token=gitops-token'"
//                 }
//             }
//        }

//         // stage("Build docker Image") {
//         //      steps {
//         //          sh 'docker build -t 02271589/SonarQube'
//         //     }
//         // }


//         // stage("Push Docker Image") {
//         //      steps {
//         //          sh 'docker push 02271589/SonarQube'
//         //     }
//         // }
//     }

//     post {
//         always {
//             deleteDir()
//         }

//         success {
//             echo 'Build is successful'
//         }

//         failure {
//             echo 'Build is not successful'
//         }
//     }   
// }








resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "main_test"
  }
}

resource "aws_subnet" "subnet_public1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "Main1"
  }
}

resource "aws_subnet" "subnet_public2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "Main2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "IGW"
  }
}

resource "aws_route_table" "awsrt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "RouteTable"
  }
}

resource "aws_route_table_association" "positive_rta1" {
  subnet_id      = aws_subnet.subnet_public1.id
  route_table_id = aws_route_table.awsrt.id
}

resource "aws_route_table_association" "positive_rta2" {
  subnet_id      = aws_subnet.subnet_public2.id
  route_table_id = aws_route_table.awsrt.id
}

resource "aws_route" "awsroute" {
  route_table_id         = aws_route_table.awsrt.id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}


resource "aws_eip" "elastic_ip_nat_gateway" {
  # vpc_id                      = true
  associate_with_private_ip = "10.0.0.10"

  tags = {
    name = "hr-app"
  }
}

########private networks#########
resource "aws_subnet" "subnet_private1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "Main1"
  }
}

resource "aws_subnet" "subnet_private2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "Main2"
  }
}

resource "aws_route_table" "negative_awsrt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "RouteTable"
  }
}

resource "aws_route_table_association" "negative_rta3" {
  subnet_id      = aws_subnet.subnet_private1.id
  route_table_id = aws_route_table.negative_awsrt.id
}


resource "aws_route_table_association" "negative_rta4" {
  subnet_id      = aws_subnet.subnet_private2.id
  route_table_id = aws_route_table.negative_awsrt.id
}