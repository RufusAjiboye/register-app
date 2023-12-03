pipeline {
    //agent {label 'jenkins-Agent'}
    agent any
    tools {
        jdk 'Java17'
        maven 'Maven3'
    }

    environment {
        APP_NAME = "pipeline10"
        RELEASE = '1.0.0'
        DOCKERHUB_USER = '02271589'
        DOCKERHUB_PASS = 'dockerhub'
        version = "v1"
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

        stage("Build and Push Image") {
            steps {
                sh '''
                docker build -t 02271589/JenkinsSonarQube:$version .
                docker push 02271589/JenkinsSonarQube:$version
                '''
            }
        }
    }
}