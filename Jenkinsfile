pipeline
{
 agent any
 	tools { nodejs "node" }

 stages{
 
  stage('Build Application'){
   steps{
script{
    configFileProvider([configFile(fileId: 'da01fc76-5c2b-4f0d-948a-c101b4cc4340', variable: 'settings')]){
  LAST_STARTED = env.STAGE_NAME
sh 'mvn -f pom.xml -s $settings clean install -DskipTests'
  }
}
  }
  }

   stage('Governance Ruleset') {
      		steps {
        		script {
	  	        	LAST_STARTED = env.STAGE_NAME
				if (fileExists('ruleset.yaml')) {
					echo "found!"					
				    }
				sh 'npm update -g anypoint-cli'
				sh 'anypoint-cli --username=jilty --password=Jilty@123 --organization=b0beec90-c6cc-4c36-8f7c-ef1f8f91253b governance api validate --rulesets ruleset.yaml  sales-jenkins-test-1302.zip'
        	            }
      		}
	} 

   stage('Publish to exchange using Anypoint Catalog CLI') {
      		steps {
        		script {
	  	        	LAST_STARTED = env.STAGE_NAME
				if (fileExists('catalog.yaml')) {
					echo "found!"					
				    }
				sh 'npm install -g api-catalog-cli@latest'
				sh 'api-catalog update-descriptor'
				sh 'api-catalog publish-asset --username=jilty --password=Jilty@123 --organization=b0beec90-c6cc-4c36-8f7c-ef1f8f91253b '
        	            }
      		}
	} 
	 
 

stage('SonarQube'){
            steps {
                withSonarQubeEnv('Sonarqube') {
                  //  sh "mvn clean org.sonarsource.scanner.maven:sonar-maven-plugin:3.9.0.2155:sonar"
                   sh "mvn -f pom.xml sonar:sonar -Dsonar.host.url=http://142.93.218.194:9000 -Dsonar.sources=src/main/mule"
           
                }
            }
        }
//         stage('Quality Gate'){
//             steps {
//                 script {
//                     timeout(time: 1, unit: 'HOURS') { 
//                         sh "curl -u admin:sonarqubenjclabs123 -X GET -H 'Accept: application/json' http://142.93.218.194:9000/api/qualitygates/project_status?projectKey=com.mycompany:sales-jenkins-test-1302 > status.json"
//                         def json = readJSON file:'status.json'
//                         echo "${json.projectStatus}"
//                         if ("${json.projectStatus.status}" != "OK") {
//                             currentBuild.result = 'FAILURE'
//                             error('Pipeline aborted due to quality gate failure.')
//                         }
//                     }
//                 }
//             }
            
//         }
 
//    stage('Build image') {
//       steps {
//         script {
//   LAST_STARTED = env.STAGE_NAME
// container_Up = false
//   sh "docker build -t apix:mule -f Dockerfile ."
               
//                         }
//                }
//       }
 

// stage('Run container') {
//       steps {
//         script {
//     LAST_STARTED = env.STAGE_NAME

//               sh ' docker run -itd -p 8095:8082 --name apix apix:mule'
// container_Up = true
// sh 'sleep 90'
//         }
// }
//      }




stage('Munit & Functional Testing'){
        steps {
script {
configFileProvider([configFile(fileId: 'da01fc76-5c2b-4f0d-948a-c101b4cc4340', variable: 'settings')]){
LAST_STARTED = env.STAGE_NAME
sh "mvn -f pom.xml -s $settings -Dhttp.port=8082 -Dproject.version=1.0.0 -Dsecure.key=mule -Dmule.env=dev -Dtestfile=src/test/javarunner.TestRunner.java test "
publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'target/site/munit/coverage', reportFiles: 'summary.html', reportName: 'Munit coverage Report', reportTitles: ''])
cucumber(failedFeaturesNumber: -1, failedScenariosNumber: -1, failedStepsNumber: -1, fileIncludePattern: 'cucumber.json', jsonReportDirectory: 'target', pendingStepsNumber: -1, skippedStepsNumber: -1, sortingMethod: 'ALPHABETICAL', undefinedStepsNumber: -1)
}
}
              }  
     }
 
 


   
 
  stage('Deploy application to cloudHub'){
   steps{
    configFileProvider([configFile(fileId: 'da01fc76-5c2b-4f0d-948a-c101b4cc4340', variable: 'settings')]){
  sh 'mvn -f pom.xml -s $settings deploy -DmuleDeploy -DskipTests -Dusername=jilty -Dpassword=Jilty@123 -DapplicationName=sales-jenkins-test-1302 -Dap.client_id=fda777bd3e3b4fcb93aff995fea2043d  -Dap.client_secret=4193AA1986054C548Bf757fd1B7F6f18 -Dapp.runtime.server=4.4.0 -Ddeployment.env=dev  -Dsecure.key=mule -Dworkers=1 -DworkerType=null -Dapi.id=18489752  -Danypoint.businessGroup="NJC POC"'


  }
   }
  }
	 
	  stage('newman tests') {
      		steps {
        		script {
	  	        	LAST_STARTED = env.STAGE_NAME
				
				sh 'newman --version'
				sh 'newman run postman-collection-cloudhub/apix-salesforce-sapi-cloudhub.postman_collection.json --global-var X-CLIENT-ID=e47be776126b417097ae4bd9d61d8b4e --global-var X-CLIENT-SECRET=B629d050f81c4204917DDE4Aa9586dBd --global-var X-CORRELATION-ID=1234 --global-var baseUrl=sales-jenkins-test-1302-dev.us-e2.cloudhub.io/api/v1 --global-var readyUrl=sales-jenkins-test-1302-dev.us-e2.cloudhub.io '
        	            }
      		}
	} 
 
 
 
 
 
  // stage('Kill container') {
  //     steps {
  //       script {
  //         LAST_STARTED = env.STAGE_NAME
  //             sh 'docker rm -f apix'
  //       }
  //     }
  //   }
 
 
  }

// post {
//         failure {
//    script {

// if (container_Up)  {
// sh 'docker rm -f apix'
// }
//    }
//         }
//     }
 }
