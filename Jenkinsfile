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
                CleanWS()
            }
        }
    }

    stage('Checkout from SCM') {
        steps {
            git branch: 'main', credentials: 'github', url: ''
        }
    }
    
}