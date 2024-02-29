pipeline {
    agent any
    tools {
        jdk 'Java17'
        maven 'Maven3'
    }

    stages {
        stage{
            steps('CleanUp Workspace') {
                cleanWs()
            }
        }

        stage{
            steps('Check out from SCM') {
                steps {
                    git branch: 'main', credentialsId: 'github', url: 'https://github.com/SoftwareDevDeveloper/register-app'
                }
            }
        }

        stage{
            steps('Build Application') {
                steps {
                    sh "mvn clean package"
                }
            }
        }

        stage{
            steps('Test Application') {
                sh "mvn test"
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