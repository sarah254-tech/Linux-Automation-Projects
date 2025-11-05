pipeline {
  agent { label 'linux' }
  environment {
    // Use your actual Docker Hub username
    IMAGE = "duckerhub254/linux-automation" 
  }
  
  stages {
    stage('Run system audit scripts') {
      environment {
        AUDIT_LOG_DIR = "${WORKSPACE}/sys_audit"
      }
      steps {
        sh '''
          echo "Current directory: $(pwd)"
          ls -la
          chmod +x ./system_audit.sh
          ./system_audit.sh
        '''
      }
    }

    stage('Run log cleaner scripts') {
      steps {
        sh '''
          chmod +x ./log_cleaner.sh
          ./log_cleaner.sh
        '''
      }
    }

    stage('Build Docker image') {
      when { 
        expression { fileExists('Dockerfile') } 
      }
      steps {
        sh 'docker build -t $IMAGE:${GIT_COMMIT ?: "latest"} .'
      }
    }

    stage('Run Tests in Container') {
      when { 
        expression { fileExists('Dockerfile') } 
      }
      steps {
        sh 'docker run --rm $IMAGE:${GIT_COMMIT ?: "latest"} /bin/sh -c "echo container test OK"'
      }
    }

    stage('Push to Docker Hub') {
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
        // Archive artifacts from the correct directory
        archiveArtifacts artifacts: 'sys_audit/**/*.log, sys_audit/**/*.html, audit_reports/**/*', allowEmptyArchive: true
      }
    }
    
    success {
      echo "✅ Build successful! All tasks completed."
    }
    
    failure {
      echo "❌ Build failed! Check the logs above for details."
    }
    
    unstable {
      echo "⚠️ Build unstable! Completed with warnings."
    }
  }
}