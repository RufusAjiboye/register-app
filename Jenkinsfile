pipeline {
    //agent {label 'jenkins-Agent'}
    agent any
    tools {
        jdk 'Java17'
        maven 'Maven3'
    }

    stages {
        stage('CleanUp workspace') {
            steps {
                cleanWS()
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

        // stage("") {
        //     steps {

        //     }
        // }

    }
}