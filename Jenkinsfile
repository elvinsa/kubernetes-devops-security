pipeline {
  agent any
  
  environment {
    deploymentName = "devsecops"
    containerName = "devsecops-container"
    serviceName = "devsecops-svc"
    imageName = "elvinsa/numeric-app"
  }

  stages {

    stage('Build Artifact - Maven') {
      steps {
        sh "mvn clean package -DskipTests=true"
        archive 'target/*.jar'
      }
    }

    stage('Unit Tests - JUnit and Jacoco') {
      steps {
        sh "mvn test"
      }
      post {
        always {
          junit 'target/surefire-reports/*.xml'
          jacoco execPattern: 'target/jacoco.exec'
        }
      }
    }
    
    stage('Mutation Tests - PIT') {
      steps {
        sh "mvn org.pitest:pitest-maven:mutationCoverage"
      }
      post {
        always {
          pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'
        }
      }
    }
     
    stage('SonarQube - SAST') {
      steps {
        withSonarQubeEnv('SonarQube') {
          sh "mvn sonar:sonar \
              -Dsonar.projectKey=devsecops-numeric-application \
              -Dsonar.host.url=http://devsecop.eastus.cloudapp.azure.com:9000/"
      }
        timeout(time: 2, unit: 'MINUTES') {
          script {
            waitForQualityGate abortPipeline: true
          }
        }
      }
    }
     
    stage('Vulnerability Scan - Docker - Trivy') {
      steps {
        parallel(
          "Dependency Scan": {
            sh "mvn dependency-check:check"
          },
          "Trivy Scan": {
            sh "bash trivy-docker-image-scan.sh"
          },
          "OPA Conftest": {
            sh 'docker run --rm -v $(pwd):/project openpolicyagent/conftest test --policy opa-docker-security.rego Dockerfile'
          }
        )
      }
    }

     
    stage('Docker image build and push') {
      steps {
          withDockerRegistry([credentialsId: "docker-hub", url: ""]) {
           sh 'printenv'
           sh 'sudo docker build -t elvinsa/numeric-app:""$GIT_COMMIT"" .'
           sh 'docker push elvinsa/numeric-app:""$GIT_COMMIT""'
       }
     }
  }

    stage('Vulnerability Scan - Kubernetes') {
      steps {
        sh 'docker run --rm -v $(pwd):/project openpolicyagent/conftest test --policy opa-k8s-security.rego k8s_deployment_service.yaml'
      }
    }

    stage('Kubernetes Deployment - DEV') {
      steps {
          withKubeConfig([credentialsId: 'kubeconfig']) {
           sh "sed -i 's#replace#elvinsa/numeric-app:${GIT_COMMIT}#g' k8s_deployment_service.yaml"
           sh "kubectl apply -f k8s_deployment_service.yaml"
        }
      }
    }
  }
}















