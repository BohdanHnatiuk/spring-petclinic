pipeline {
    agent any
    tools {
        maven 'mvn'
        jdk 'jdk8'
    } 
    environment {
        DOCKER_IMAGE_NAME = "bohdanhnatiuk/petclinic"
        //registry = "bohdanhnatiuk/petclinic" 
        registryCredential = 'docker_hub_login' 
        //dockerImage = ''         
    }
    stages {

        stage('Compile') {
            steps {
            sh 'mvn compile' //only compilation of the code
            }
        } 
        stage('Test') {
            steps {
                sh '''
                mvn clean package  
                ls
                pwd
                ''' 
            //if the code is compiled, we test and package it in its distributable format; run IT and store in local repository
            }
        }
        stage('Build Docker Image') {
            when {
                branch 'main'
            }
            steps {
                script {
                    app = docker.build(DOCKER_IMAGE_NAME)
                   // app.inside {
                   //     sh 'echo Hello, World!'
                   // }
                }
            }
        }
        stage('Push Docker Image') {
            when {
                branch 'main'
            }
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', registryCredential) {
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                    }
                }
            }
        }

    }
}
