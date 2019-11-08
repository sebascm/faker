pipeline {
    agent { docker { image 'python' } }
    stages {
        stage('Setup Workspace') {
            steps {
                sh 'mkdir reports'
								sh 'pip install flake8 bandit'
            }
        }
        stage('Validate') {
            steps {
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
								sh 'time python setup.py test &> /dev/null'
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
                        sh "git config --global user.name 'Sebas Calvo'" //may be are multiple sebas in a development team
                        sh "git remote update"
                        sh "git fetch --all"
                        sh "git pull --all"
                        sh "git checkout dev"
                        sh "git merge origin/master"
                        sh "git merge ${BRANCH_NAME}"
                        sh "git push https://$user:$pass@github.com/sebascm/faker/"
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
