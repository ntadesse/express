pipeline {
    agent any
    tools {
        nodejs 'nodejs-16.20.2'
    }
    stages {
        stage('Print NodeJS and NPM Versions') {
            steps {
                sh 'node -v'
                sh 'npm -v'
            }
        }
    }
}
