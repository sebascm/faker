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
                sh 'curl -o benchmark.sh -s https://gist.githubusercontent.com/sebascm/c56b26bc24d8964c005cfae95c853e5c/raw/f4cfd88af7049acaff89d2ef68ae5d40f666ee46/benchmark.sh'
                sh 'bash benchmark.sh >> reports/benchmarks.txt'
            }
        }
    }  
    post {
        success{
            archiveArtifacts artifacts: 'build.tar.gz'
            sh 'tar -cvzf reports.tar.gz reports/'
            archiveArtifacts 'reports.tar.gz'
            script{
                if (env.BRANCH_NAME.startsWith('PR')){
                    withCredentials([usernamePassword(credentialsId: 'SebasGH', passwordVariable: 'pass', usernameVariable: 'user')]) {
                        sh "git config --global user.email 'sebastiancalvom@gmail.com'"
                        sh "git config --global user.name 'Sebas'"
                        sh "git remote update"
                        sh "git fetch --all"
                        sh "git pull --all"
                        sh "git checkout origin/dev"
                        sh "git merge origin/master"
                        sh "git merge ${BRANCH_NAME}"
                        sh "git push https://$user:$pass@github.com/sebascm/faker/ HEAD:origin/dev"
                    }
                }
            }
        }
        always {
            sh 'tar -cvzf reports.tar.gz reports/'
            archiveArtifacts 'reports.tar.gz'
            emailext (
                attachmentsPattern: 'reports.tar.gz',
                subject: "[JENKINS] Job '${env.JOB_NAME} execution result'",
                from: 'notificaciones.torusnewies@gmail.com',
                to: 'sebastiancalvom@gmail.com',
                body: " Job: '${env.JOB_NAME} \n\tBuild: [${env.BUILD_NUMBER}] \n\tStatus: ${currentBuild.currentResult}"
            )
        }
        cleanup {
            cleanWs()       
        }
    }
}
