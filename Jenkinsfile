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
                sh 'flake8 > reports/flake8.txt'
                sh 'flake8 --select=DUO > reports/dlint.txt'
            }
        }
        stage('Build') {
            steps {
                sh 'pip install .'
                sh 'pip install freezegun'
                sh 'pip install validators'
                sh 'pip install ukpostcodeparser'
                sh 'pip install random2'
                sh 'pip install pytest'
            }
        }
        stage('Tests') {
            steps {
                sh 'py.test -rA > reports/tests.txt'
            }
        }
        stage('Package') {
            steps {
                sh 'python setup.py build'
            }
        }
        stage('Verify') {
            steps {
                sh 'pip install bandit'
                sh 'bandit -lll -s B303 -r . -o "reports/bandit.txt"'
            }
        }
        stage('Deploy') {
            steps {
                sh 'tar -cvzf build.tar.gz build/'
                sh 'tar -cvzf reports.tar.gz reports/'
            }
        }
    }
    post {
        always {
            archiveArtifacts 'reports.tar.gz'
            archiveArtifacts artifacts: 'build.tar.gz', onlyIfSuccessful: true
            cleanWs()
        }
    }
}
