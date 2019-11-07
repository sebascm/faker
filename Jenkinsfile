pipeline {
    agent { docker { image 'python' } }
    stages {
        stage('Setup Workspace') {
            steps {
                sh 'mkdir reports'
            }
        }
        stage('Validate') {
            steps {
                sh 'pip install flake8'
                sh 'flake8 > reports/flake8.txt'
                sh 'flake8 --select=DUO > reports/dlint.txt'
            }
        }
         stage('Tests') {
            steps {
                sh 'python setup.py test > reports/tests.txt'
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
                sh 'bandit -lll -s B303,B605,B602 -r . -o "reports/bandit.txt"'
            }
        }
        stage('Deploy') {
            steps {
                sh 'tar -cvzf build.tar.gz build/'
            }
        }
        stage ('Benchmark'){
            steps {
                sh 'bash tests/benchmarks/benchmark.sh >> reports/benchmarks.txt'
            }
        }
    }
    post {
				success{
						archiveArtifacts artifacts: 'build.tar.gz'
				}
				always {
						sh 'tar -cvzf reports.tar.gz reports/'
            archiveArtifacts 'reports.tar.gz'
            emailext (
                attachmentsPattern: 'reports.tar.gz',
                subject: "[JENKINS] Job '${env.JOB_NAME} execution result'",
                from: 'notificaciones.torusnewies@gmail.com',
                to: 'fran.rua@torusware.com',
                body: " Job: '${env.JOB_NAME} \n\tBuild: [${env.BUILD_NUMBER}] \n\tStatus: ${currentBuild.currentResult}"
            )
				}
        cleanup {
            deleteDir()       
        }
    }
}
