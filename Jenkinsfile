pipeline {
    //agent {label 'jenkins-Agent'}
    agent any
    tools {
        jdk 'Java17'
        maven 'Maven3'
    }

    environment {
            ACCCESS_KEY_ID = credentials ('ACCESS_KEY_ID')
            SECRET_ACCESS_KEY = credentials('SECRET_ACCESS_KEY')

            hub_username = credentials ('hub-username')
            hub_password = credentials ('hub-password')
            // APP_NAME = "pipeline10"
            // RELEASE = "1.0.0"
            // DOCKERHUB_USER = "02271589"
            // DOCKERHUB_PASS = "dockerhub"
            // IMAGE_NAME = "${DOCKERHUB_USER}" + "/" + "${APP_NAME}"
            // IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"
    }

    stages {
        stage('Cleanup workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout from SCM') {
            steps {
                git branch: 'main', credentialsId: 'github', url: 'https://github.com/SoftwareDevDeveloper/register-app'
            }
        }

        stage('Build Application') {
            steps {
                sh "mvn clean package"
            }
        }

        stage("Test Application") {
            steps {
                sh "mvn test"
            }
        }


        stage("SonarQube Anlysis") {
            steps {
                script {
                    withSonarQubeEnv(credentialsId: 'jenkins-sonarqube-token') {
                    sh "mvn sonar:sonar"
                    }
                }
            }
        }

        stage("Quality Gate") {
            steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'jenkins-sonarqube-token'
                }
            }
        }

        // stage("Build and push Image") {
        //     steps{
        //         script{
        //             docker.withRegistry('', DOCKERHUB_PASS) {
        //                  docker_image = docker.build "${IMAGE_NAME}"
        //             }

        //             docker.withRegistry('',DOCKERHUB_PASS) {
        //                 docker_image.push("${IMAGE_TAG}")
        //                 docker_image.push('latest')
        //             }
        //         }
        //     }
        // }


        // stage("Build docker Image") {
        //      steps {
        //          sh 'docker build -t 02271589/SonarQube'
        //     }
        // }


        // stage("Push Docker Image") {
        //      steps {
        //          sh 'docker push 02271589/SonarQube'
        //     }
        // }
    }

    post {
        always {
            deleteDir()
        }

        success {
            echo 'Build is successful'
        }

        failure {
            echo 'Build is not successful'
        }
    }   
}