pipeline {
    agent { docker { image 'python' } }
    stages {
        stage('Setup Workspace') {
            steps {
                sh 'echo Configure workspace'
            }
        }
        stage('Validate') {
            steps {
                sh 'pip install flake8'
		sh 'flake8'
                sh 'flake8 --select=DUO'
            }
        }
        stage('Build') {
            steps {
                sh 'echo Build'
            }
        }
        stage('Tests') {
            steps {
                sh 'echo Execute unit and integration tests'
            }
        }
        stage('Package') {
            steps {
                sh 'echo Package software'
            }
        }
        stage('Verify') {
            steps {
                sh 'echo Run Bandit'
            }
        }
        stage('Deploy') {
            steps {
                sh 'echo Deploy'
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}
