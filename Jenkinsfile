pipeline {
    agent any
    tools {
        nodejs 'nodejs'
    }
    environment {
        MONGO_URI="mongodb+srv://supercluster.d83jj.mongodb.net/superData"
        MONGO_DB_CREDS = credentials('mongo-db-credentials')
        MONGO_USERNAME = credentials('mongo-db-username')
        MONGO_PASSWORD = credentials('mongo-db-password')
        SONAR_SCANNER_HOME = tool 'sonar-scanner-610'
    }
    options {
        disableResume()
        disableconcurrentBuilds abortPrevious: true
    }

    stages {
        stage('VM Node Version') {
            steps {
                sh '''
                  node --version
                  npm --version
                '''
            }
        }
    }
   stage('Installing Dependencies') {
      options { timestamps() }
      steps {
            sh 'sleep 100s'
            sh 'npm install --no-audit'
            }
        }
    stage('Dependency Check'){
        parallel {
        stage('NPM Audit') {
            steps {
                sh 'npm audit --audit-level=critical'
                }
            }
        stage('OWASP Dependency Check') {
            steps {
                dependencyCheck additionalArguments: '''
                    --scan \'./\'
                    --out \'./\'
                    --format \'ALL\'
                    --disableYarnAudit \
                    --prettyPrint''', odcInstallation: 'OWASP-DepCheck-10'
                dependencyCheckPublisher pattern: failedTotalCritical:1, pattern: 'dependency-check-report.xml', stopBuild: true
                junit allowEmptyResults: true, studioRetention: '',  testResults: 'dependency-check-jun.xml'
                publishHTML([allowMissing: true, alwaysLinkToLastBuild: true, keepAll: true, reportDir: './', reportFiles: 'dependency-check-jenkins.html', reportName: 'Dependency Check Report HTML', reportTitles: '', useWrapperFileDirectly: true])
                 }
              }
           }
        }
        stage('Unit Testing') {
            options { retery (2)}
            steps {
                withCredentials([usernamePassword(credentialId: '', passwordVariable: 'MONGO_PASSWORD', usernameVariable: 'MONGO_USERNAME')]) 
                    sh 'npm test'
        }
    }
}
