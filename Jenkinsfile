pipeline {
  agent any

  stages {

      stage('Build Artifact') {
            steps {
              sh "mvn clean package -DskipTests=true"
              archive 'target/*.jar'
            }
        }      

      
      stage('Unit Tests') {
            steps {
              sh "mvn test"
            }
          }  

      stage('Docker Build and Push') {
        steps {
           script {
               try {
                 // Log in to Docker Hub using --password-stdin
                 sh "echo '<your-docker-password>' | docker login --username elvinsa --password-stdin https://index.docker.io/v1/"

                 // Build and push the Docker image
                 sh "docker build -t siddharth67/numeric-app:$GIT_COMMIT ."
                 sh "docker push siddharth67/numeric-app:$GIT_COMMIT"
               } catch (Exception e) {
                 currentBuild.result = 'FAILURE'
                 error("Failed to build and push Docker image: ${e.message}")
            }
        }
    }
  }
} 

