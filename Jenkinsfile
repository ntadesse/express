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
        stage('Code Coverage') {
            steps {
                withCredentials([usernamePassword(credentialId: '', passwordVariable: 'MONGO_PASSWORD', usernameVariable: 'MONGO_USERNAME')]) 
                    catchError(buildResult: 'SUCCESS', message: 'Ooops! Code coverage failed!', stageResult: 'UNSTABLE') {
                    sh 'npm run coverage'
           }
           publishHTML([allowMissing: true, alwaysLinkToLastBuild: true, keepAll: true, reportDir: 'coverage/local-result/', reportFiles: 'index.html', reportName: 'Code Coverage Report HTML', reportTitles: '', useWrapperFileDirectly: true])
        }
    }
        stage('SAST SonarQube') {
            steps {
                timeout(time: 60s, unit: 'SECONDS') {
                    withSonarQubeEnv('sonar-qube-server') {
                    sh 'echo $SONAR_SCANNER_HOME'
                    sh '''
                        $SONAR_SCANNER_HOME/bin/sonar-scanner \
                        -Dsonar.projectKey=solar-sysetm-project \ 
                        -Dsonar.sources=. \
                        -Dsonar.javascript.lcov.reportPaths=./coverage/lcov.info \
                    '''
            }
            waitForQualityGate abortPipeline: true
        }
    }
  }
}
