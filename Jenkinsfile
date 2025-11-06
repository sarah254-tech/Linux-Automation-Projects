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
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh '''
            # echo $DOCKER_PASS | docker login -u "$DOCKER_USER" --password-stdin
            # push $IMAGE:latest

            echo "=== JENKINS CREDENTIAL DEBUG ==="
            echo "DOCKER_USER: '$DOCKER_USER'"
            echo "DOCKER_PASS length: ${#DOCKER_PASS}"
            echo "DOCKER_PASS first 10 chars: '${DOCKER_PASS:0:10}'"
            echo "DOCKER_PASS last 10 chars: '${DOCKER_PASS: -10}'"
            
            # Write to file to check for hidden characters
            echo "$DOCKER_PASS" > /tmp/token.txt
            echo "Token file size: $(wc -c < /tmp/token.txt) bytes"
            echo "Token hex dump:"
            hexdump -C /tmp/token.txt | head -5
            
            # Test the actual login
            echo "Testing Docker login..."
            cat /tmp/token.txt | docker login -u "$DOCKER_USER" --password-stdin
          '''
        }
      }
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