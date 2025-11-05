pipeline {
  agent { label 'linux' }
  
  
  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Run system audit scripts') {
      steps {
        sh '''
          chmod +x ./system_audit.sh || true
          ./system_audit.sh
        '''
      }
    }

    stage('Run log cleaner scripts') {
      steps {
        sh '''
          chmod +x ./log_cleaner.sh || true
          ./log_cleaner.sh
        '''
      }
    }

    stage('Build Docker image (optional)') {
      when { 
        expression { fileExists('Dockerfile') } 
      }
      steps {
        sh 'docker build -t $IMAGE:${GIT_COMMIT ?: "latest"} .'
      }
    }

    stage('Run Tests in Container (optional)') {
      when { 
        expression { fileExists('Dockerfile') } 
      }
      steps {
        sh 'docker run --rm $IMAGE:${GIT_COMMIT ?: "latest"} /bin/sh -c "echo container test OK"'
      }
    }

    stage('Push to Docker Hub (optional)') {
      when { 
        expression { fileExists('Dockerfile') } 
      }
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh '''
            echo $DOCKER_PASS | docker login -u "$DOCKER_USER" --password-stdin
            docker push $IMAGE:${GIT_COMMIT ?: "latest}"
          '''
        }
      }
    }
  }
  
  post {
    always {
      echo "Build completed - Result: ${currentBuild.result}"
      script {
        // Archive important artifacts if they exist
        archiveArtifacts artifacts: '**/*.log, **/audit-report*.txt', allowEmptyArchive: true
      }
    }
    
    success {
      echo "Build successful! Sending email notification..."
      emailext (
        subject: "✅ SUCCESS: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
        body: """
          <h2>Build Successful! ✅</h2>
          <p><strong>Job:</strong> ${env.JOB_NAME}</p>
          <p><strong>Build Number:</strong> ${env.BUILD_NUMBER}</p>
          <p><strong>Status:</strong> SUCCESS</p>
          <p><strong>Duration:</strong> ${currentBuild.durationString}</p>
          <p><strong>URL:</strong> <a href="${env.BUILD_URL}">${env.BUILD_URL}</a></p>
          <p><strong>Git Commit:</strong> ${env.GIT_COMMIT}</p>
          <br/>
          <p>All system audit and log cleaning tasks completed successfully.</p>
        """,
        to: "sarahamadi97@gmail.com", // Change to your email
        recipientProviders: [[$class: 'DevelopersRecipientProvider']]
      )
    }
    
    failure {
      echo "Build failed! Sending email notification..."
      emailext (
        subject: "❌ FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
        body: """
          <h2>Build Failed! ❌</h2>
          <p><strong>Job:</strong> ${env.JOB_NAME}</p>
          <p><strong>Build Number:</strong> ${env.BUILD_NUMBER}</p>
          <p><strong>Status:</strong> FAILED</p>
          <p><strong>Duration:</strong> ${currentBuild.durationString}</p>
          <p><strong>URL:</strong> <a href="${env.BUILD_URL}">${env.BUILD_URL}</a></p>
          <p><strong>Console Log:</strong> <a href="${env.BUILD_URL}console">View Log</a></p>
          <br/>
          <p>Please check the build logs for details on what went wrong.</p>
        """,
        to: "sarahamadi97@gmail.com", // Change to your email
        recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']]
      )
    }
    
    unstable {
      echo "Build unstable! Sending email notification..."
      emailext (
        subject: "⚠️ UNSTABLE: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
        body: """
          <h2>Build Unstable! ⚠️</h2>
          <p><strong>Job:</strong> ${env.JOB_NAME}</p>
          <p><strong>Build Number:</strong> ${env.BUILD_NUMBER}</p>
          <p><strong>Status:</strong> UNSTABLE</p>
          <p><strong>Duration:</strong> ${currentBuild.durationString}</p>
          <p><strong>URL:</strong> <a href="${env.BUILD_URL}">${env.BUILD_URL}</a></p>
          <br/>
          <p>The build completed but with some warnings or test failures.</p>
        """,
        to: "sarahamadi97@gmail.com" // Change to your email
      )
    }
  }
}