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

      stage('Docker build and push') {
            steps {
              withDockerRegistry([credentialsId: "docker-hub", url: ""]) {
                    sh 'printenv'
                    sh 'docker bulid -t siddharth67/numeric-app:""$GIT_COMMIT"" .'
                    sh 'docker push siddharth67/numeric-app:""$GIT_COMMIT""' 
                }           
           }
        }   
    }
}