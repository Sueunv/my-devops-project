pipeline {
  agent any

  environment {
    AWS_ACCESS_KEY_ID     = credentials('aws-access-key')
    AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
  }

  stages {
    stage('Clone Repo') {
      steps {
        git 'https://github.com/Sueunv/my-devops-project.git'
      }
    }

    stage('Terraform Init') {
      steps {
        sh 'terraform init'
      }
    }

    stage('Terraform Apply') {
      steps {
        sh 'terraform apply -auto-approve'
      }
    }

    stage('Deploy Docker App') {
      steps {
        script {
          def ec2_ip = sh(script: "terraform output -raw public_ip", returnStdout: true).trim()
          sh """
          ssh -o StrictHostKeyChecking=no -i /home/ubuntu/gitkey.pem  ubuntu@$ec2_ip '
          docker run -d -p 80:80 nginx'
          """
        }
      }
    }
  }
}

