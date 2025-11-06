pipeline {
  agent { label 'linux' }
  
  environment {
    IMAGE = "duckerhub254/linux-automation" 
    AUDIT_LOG_DIR = "${WORKSPACE}/sys_audit"
  }
  
  stages {
    stage('Run system audit scripts') {
      steps {
        sh '''
          echo "=== System Audit ==="
          chmod +x ./system_audit.sh
          ./system_audit.sh
        '''
      }
    }

    stage('Run log cleaner scripts') {
      steps {
        sh '''
          echo "=== Log Cleaner ==="
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
        sh 'docker build -t $IMAGE:latest .'
      }
    }

    stage('Run Tests in Container') {
      when { 
        expression { fileExists('Dockerfile') } 
      }
      steps {
        sh 'docker run --rm $IMAGE:latest /bin/sh -c "echo container test OK"'
      }
    }

    stage('Push to Docker Hub') {
  when { 
    expression { fileExists('Dockerfile') } 
  }
  steps {
    sh '''
      echo "Skipping Docker login and push for now (public image build test)"
    '''
  }
}
  
  post {
    always {
      echo "Build completed - Result: ${currentBuild.result}"
      archiveArtifacts artifacts: 'sys_audit/**/*', allowEmptyArchive: true
    }
    success {
      echo "🎉 SUCCESS: All stages completed successfully!"
    }
    failure {
      echo "❌ FAILURE: Check logs above for errors."
    }
  }
}
}