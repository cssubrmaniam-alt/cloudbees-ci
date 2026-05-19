pipeline {
    agent { label 'traditional-linux' }

    stages {
        stage('Multibranch Validate') {
            steps {
                sh '''
                    echo "Phase 2F Multibranch smoke test"
                    hostname
                    whoami
                    java -version
                '''
            }
        }
    }
}
