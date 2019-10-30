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
                sh 'pip install .'
                sh 'pip install freezegun'
                sh 'pip install validators'
                sh 'pip install ukpostcodeparser'
                sh 'pip install random2'
            }
        }
        stage('Tests') {
            steps {
                sh 'py.test'
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
