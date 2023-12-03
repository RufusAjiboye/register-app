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
        hub_username = credentials ('hub-username')
        hub_password = credentials ('hub-password')
        version = "v3"
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

        // stage("Build and Push Image") {
        //     steps {
        //         sh 'docker build -t 02271589/SonarQube'
        //     }
        // }

        stage('Build the docker image') {
            steps  {
                sh '''
                    docker build -t 02271589/sonarqube:$version .
                '''
            }
        }

        stage('Run docker image') {
            steps  { 
                sh 'docker run -d -p 80:5000 02271589/sonarqube:$version'
            }
        }

        stage ('login to the image repo') {
            steps {
                  echo "login to docker hub repo"
                  sh 'docker login -u $hub_username -p $hub_password'
            }
        }

        stage ('publish image to dockerhub') {
            steps {
                  echo "Push image to the Image repo"
                  sh 'docker push 02271589/sonarqube:$version'     
            }
        }  
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