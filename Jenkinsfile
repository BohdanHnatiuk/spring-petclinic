pipeline {
   // agent any
    agent {
    kubernetes {
    yaml """\
      apiVersion: v1
      kind: Pod
      metadata:
        labels:
          deployer: java-app
      spec:
        containers:
        - name: helm
          image: alpine/helm
          command:
          - cat
          tty: true
        serviceAccount: jenkins
      """.stripIndent()     
    }
  }
    tools {
        maven 'mvn'
        jdk 'jdk'
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
                mvn clean install
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
        stage('DEPLOY JAVA APP') {
          steps {
              container ('helm') {
                  script {
                      sh """
                      helm repo add myrepo  https://bohdanhnatiuk.github.io/charts/
                      helm --debug install \
                              --namespace test \
                              petclinic myrepo/petclinic \
                              --set service.type=NodePort \
                              --version 0.1.0
                      """
                  }
              }
          }
      }

    }
}
