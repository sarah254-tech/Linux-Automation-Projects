pipeline {
  agent { label 'linux' }

  environment {
    IMAGE = "dockerhub254/linux-automation"
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

    stage('Test API Access') {
      steps {
    sh '''
      echo "Testing API connectivity..."
      curl -v https://jsonplaceholder.typicode.com/users
    '''
    
      }
    }

    stage('Fetch API Data') {
      steps {
    sh '''
      echo "Fetching users data..."
      response=$(curl -s https://jsonplaceholder.typicode.com/users)
      echo "$response" | jq .
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

    stage('Run API data collector script') {
      steps {
        sh '''
          echo "=== API Data Collector ==="
          chmod +x ./api_data_collector.sh
          ./api_data_collector.sh
        '''
      }
    }

    stage('Build Docker image') {
      when { expression { fileExists('Dockerfile') } }
      steps {
        sh 'docker build -t $IMAGE:latest .'
      }
    }

    stage('Run Tests in Container') {
      when { expression { fileExists('Dockerfile') } }
      steps {
        sh 'docker run --rm $IMAGE:latest /bin/sh -c "echo container test OK"'
      }
    }

    stage('Build and Push to Docker Hub') {
      when { expression { fileExists('Dockerfile') } }
      steps {
        script {
          docker.withRegistry('https://registry.hub.docker.com', 'dockerhub-credentials') {
            def app = docker.build("${IMAGE}:latest")
            app.push()
          }
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
      echo "SUCCESS: All stages completed successfully!"
    }
    failure {
      echo "FAILURE: Check logs above for errors."
    }
  }
}




   
