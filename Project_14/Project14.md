# EXPERIENCE CONTINUOUS INTEGRATION WITH JENKINS | ANSIBLE | ARTIFACTORY | SONARQUBE | PHP



### Configuring Ansible For Jenkins Development

- Update the inventory file for each envionment


- Install Blue Ocean Jenkins Plugin and create new pipeline in the Blue Ocean UI
![Screenshot from 2022-03-04 21-44-05](https://user-images.githubusercontent.com/80127136/157780439-bba53119-1b6c-4e32-825c-6a577ebb2909.png)
![Screenshot from 2022-03-04 21-49-58](https://user-images.githubusercontent.com/80127136/157780462-59ee6a1f-468e-451b-b9b4-152dffa53d7f.png)

- Create token on github to connect the github repository ansible-config-mgt with jenkins
![Screenshot from 2022-03-04 21-53-54](https://user-images.githubusercontent.com/80127136/157780479-ca222284-9a3c-4e7f-b628-766189b5f174.png)
![Screenshot from 2022-03-04 21-54-48](https://user-images.githubusercontent.com/80127136/157780499-50e3e0e2-0458-4296-8e36-31067516109c.png)

- Then create jenkinsfile in deploy directory in the github repository then add the the code snippet below to it to start the jenkinsfile gradually.

```
  stages {
    stage('Build') {
      steps {
        script {
          sh 'echo "Building Stage"'
        }
      }
    }
    }
}
```
![Screenshot from 2022-03-04 21-58-36](https://user-images.githubusercontent.com/80127136/157780570-7c19e385-c821-443b-ba09-aba2afabe446.png)


- The configure the project created to build Jenkinsfile and specify the location and build.
![Screenshot from 2022-03-04 22-01-00](https://user-images.githubusercontent.com/80127136/157780621-44077464-22ec-487c-81db-cfa324063813.png)
![Screenshot from 2022-03-04 22-17-27](https://user-images.githubusercontent.com/80127136/157780674-40b8f43d-5309-4821-a99e-a30bb470e5a5.png)
![Screenshot from 2022-03-04 22-23-08](https://user-images.githubusercontent.com/80127136/157780727-0e435bc4-91c8-4c93-be6e-15a7885c92aa.png)

- Then create a new branch and name it feature/jenkinspipeline-stages and create stages package, deploy and clean up then click "scan Repository Now" and you will see the new branch build automatically.
![Screenshot from 2022-03-04 22-53-29](https://user-images.githubusercontent.com/80127136/157780703-77b0a75b-dad0-41f1-a501-fa92c1a19a53.png)

### Running Ansible Playbook From Jenkins

- Install ansible plugin on jenkins UI
![Screenshot from 2022-03-04 23-11-14](https://user-images.githubusercontent.com/80127136/157780323-230e0489-3063-4fda-bd35-b06fe7cd14d4.png)
![Screenshot from 2022-03-04 23-14-03](https://user-images.githubusercontent.com/80127136/157780304-c0cca784-a410-4991-9225-63557f1d2695.png)

- Create Jenkinsfile from scratch.

- Configure the jenkins file to run ansible against Dev environment successfully.
![Screenshot from 2022-03-05 01-35-29](https://user-images.githubusercontent.com/80127136/157780846-988cfe67-9977-4fe1-9741-30f75020c62a.png)
![Screenshot from 2022-03-05 03-18-17](https://user-images.githubusercontent.com/80127136/157780989-e671e912-3b82-4efd-8b21-cf519221314a.png)
![Screenshot from 2022-03-05 13-03-31](https://user-images.githubusercontent.com/80127136/157781031-81f23439-80b4-42a2-b66b-03f97a7e5601.png)

- Ensure the the git module in Jenkinsfile is checking out SCM to main branch.

- Put the .ansible.cfg file from the jenkins server alongside Jenkinfile in the deploy directory. Using the pipeline syntax tool in Ansible, generate the syntax to create environment variables to set.

### Parameterizing Jenkinsfile For Ansible Deployment

- Update the sit inventory file with
![Screenshot from 2022-03-05 11-34-27](https://user-images.githubusercontent.com/80127136/157780914-ac2576b7-bb7d-482c-bb85-7d88d9363062.png)

```
[tooling]
<SIT-Tooling-Web-Server-Private-IP-Address>

[todo]
<SIT-Todo-Web-Server-Private-IP-Address>

[nginx]
<SIT-Nginx-Private-IP-Address>

[db:vars]
ansible_user=ec2-user
ansible_python_interpreter=/usr/bin/python

[db]
<SIT-DB-Server-Private-IP-Address>
```

- Update the jenkinsfile to introduce parameterization with the code below then update the inventory file path with "${inventory}".
![Screenshot from 2022-03-05 13-08-21](https://user-images.githubusercontent.com/80127136/157781214-c5bd29fb-a79b-4d4e-bd92-9f9029f14c83.png)

```
parameters {
      string(name: 'inventory', defaultValue: 'dev',  description: 'This is the inventory file for the environment to deploy configuration')
    }
```

- Then introduce tags to the ansible playbook to limit the tasks to the tag specified in the jenkins UI or jenkinsfile

![Screenshot from 2022-03-05 13-40-46](https://user-images.githubusercontent.com/80127136/157781319-e67cf328-b8f2-461c-98dc-817a62837e1d.png)

![Screenshot from 2022-03-05 13-42-46](https://user-images.githubusercontent.com/80127136/157781258-ea3f09c0-b52b-418f-a24e-761f7e0f6502.png)


### CI/CD PIPELINE FOR TODO APPLICATION

- Fork the repository below into your GitHub account.
"https://github.com/darey-devops/php-todo.git"



- On you Jenkins server, install PHP, its dependencies and Composer tool
![Screenshot from 2022-03-05 20-15-51](https://user-images.githubusercontent.com/80127136/157781460-3bfc2440-4eeb-4632-8240-81026942e6b0.png)



- Install plots and artifactory plugin.
![Screenshot from 2022-03-05 20-07-24](https://user-images.githubusercontent.com/80127136/157781437-db9f8e4c-6f53-473e-b7a2-1f6156daad36.png)



- Create a jenkinsfile in the repository



- On the database server create database and user with:

```

Create database homestead;
CREATE USER 'homestead'@'%' IDENTIFIED BY 'sePret^i';
GRANT ALL PRIVILEGES ON * . * TO 'homestead'@'%';
```

- Update the database connectivity requirements in the file .env.sample in the repository
![Screenshot 2022-03-09 055124](https://user-images.githubusercontent.com/80127136/157784058-20f51380-2006-4738-99bf-5796545f1ae6.png)

- Update jenkinsfile with the repository

```
pipeline {
    agent any

  stages {

     stage("Initial cleanup") {
          steps {
            dir("${WORKSPACE}") {
              deleteDir()
            }
          }
        }

    stage('Checkout SCM') {
      steps {
            git branch: 'main', url: 'https://github.com/darey-devops/php-todo.git'
      }
    }

    stage('Prepare Dependencies') {
      steps {
             sh 'mv .env.sample .env'
             sh 'composer install'
             sh 'php artisan migrate'
             sh 'php artisan db:seed'
             sh 'php artisan key:generate'
      }
    }
  }
}
```
![Screenshot from 2022-03-07 02-44-47](https://user-images.githubusercontent.com/80127136/157782292-ee0cdde7-3a97-4ed3-a7d4-798d2d0382d7.png)


- Add the code analysis step in the Jenkinsfile



```
stage('Code Analysis') {
  steps {
        sh 'phploc app/ --log-csv build/logs/phploc.csv'

  }
}
```

- Plot the data using plot Jenkins plugin installed



``` 
stage('Plot Code Coverage Report') {
      steps {

            plot csvFileName: 'plot-396c4a6b-b573-41e5-85d8-73613b2ffffb.csv', csvSeries: [[displayTableFlag: false, exclusionValues: 'Lines of Code (LOC),Comment Lines of Code (CLOC),Non-Comment Lines of Code (NCLOC),Logical Lines of Code (LLOC)                          ', file: 'build/logs/phploc.csv', inclusionFlag: 'INCLUDE_BY_STRING', url: '']], group: 'phploc', numBuilds: '100', style: 'line', title: 'A - Lines of code', yaxis: 'Lines of Code'
            plot csvFileName: 'plot-396c4a6b-b573-41e5-85d8-73613b2ffffb.csv', csvSeries: [[displayTableFlag: false, exclusionValues: 'Directories,Files,Namespaces', file: 'build/logs/phploc.csv', inclusionFlag: 'INCLUDE_BY_STRING', url: '']], group: 'phploc', numBuilds: '100', style: 'line', title: 'B - Structures Containers', yaxis: 'Count'
            plot csvFileName: 'plot-396c4a6b-b573-41e5-85d8-73613b2ffffb.csv', csvSeries: [[displayTableFlag: false, exclusionValues: 'Average Class Length (LLOC),Average Method Length (LLOC),Average Function Length (LLOC)', file: 'build/logs/phploc.csv', inclusionFlag: 'INCLUDE_BY_STRING', url: '']], group: 'phploc', numBuilds: '100', style: 'line', title: 'C - Average Length', yaxis: 'Average Lines of Code'
            plot csvFileName: 'plot-396c4a6b-b573-41e5-85d8-73613b2ffffb.csv', csvSeries: [[displayTableFlag: false, exclusionValues: 'Cyclomatic Complexity / Lines of Code,Cyclomatic Complexity / Number of Methods ', file: 'build/logs/phploc.csv', inclusionFlag: 'INCLUDE_BY_STRING', url: '']], group: 'phploc', numBuilds: '100', style: 'line', title: 'D - Relative Cyclomatic Complexity', yaxis: 'Cyclomatic Complexity by Structure'      
            plot csvFileName: 'plot-396c4a6b-b573-41e5-85d8-73613b2ffffb.csv', csvSeries: [[displayTableFlag: false, exclusionValues: 'Classes,Abstract Classes,Concrete Classes', file: 'build/logs/phploc.csv', inclusionFlag: 'INCLUDE_BY_STRING', url: '']], group: 'phploc', numBuilds: '100', style: 'line', title: 'E - Types of Classes', yaxis: 'Count'
            plot csvFileName: 'plot-396c4a6b-b573-41e5-85d8-73613b2ffffb.csv', csvSeries: [[displayTableFlag: false, exclusionValues: 'Methods,Non-Static Methods,Static Methods,Public Methods,Non-Public Methods', file: 'build/logs/phploc.csv', inclusionFlag: 'INCLUDE_BY_STRING', url: '']], group: 'phploc', numBuilds: '100', style: 'line', title: 'F - Types of Methods', yaxis: 'Count'
            plot csvFileName: 'plot-396c4a6b-b573-41e5-85d8-73613b2ffffb.csv', csvSeries: [[displayTableFlag: false, exclusionValues: 'Constants,Global Constants,Class Constants', file: 'build/logs/phploc.csv', inclusionFlag: 'INCLUDE_BY_STRING', url: '']], group: 'phploc', numBuilds: '100', style: 'line', title: 'G - Types of Constants', yaxis: 'Count'
            plot csvFileName: 'plot-396c4a6b-b573-41e5-85d8-73613b2ffffb.csv', csvSeries: [[displayTableFlag: false, exclusionValues: 'Test Classes,Test Methods', file: 'build/logs/phploc.csv', inclusionFlag: 'INCLUDE_BY_STRING', url: '']], group: 'phploc', numBuilds: '100', style: 'line', title: 'I - Testing', yaxis: 'Count'
            plot csvFileName: 'plot-396c4a6b-b573-41e5-85d8-73613b2ffffb.csv', csvSeries: [[displayTableFlag: false, exclusionValues: 'Logical Lines of Code (LLOC),Classes Length (LLOC),Functions Length (LLOC),LLOC outside functions or classes ', file: 'build/logs/phploc.csv', inclusionFlag: 'INCLUDE_BY_STRING', url: '']], group: 'phploc', numBuilds: '100', style: 'line', title: 'AB - Code Structure by Logical Lines of Code', yaxis: 'Logical Lines of Code'
            plot csvFileName: 'plot-396c4a6b-b573-41e5-85d8-73613b2ffffb.csv', csvSeries: [[displayTableFlag: false, exclusionValues: 'Functions,Named Functions,Anonymous Functions', file: 'build/logs/phploc.csv', inclusionFlag: 'INCLUDE_BY_STRING', url: '']], group: 'phploc', numBuilds: '100', style: 'line', title: 'H - Types of Functions', yaxis: 'Count'
            plot csvFileName: 'plot-396c4a6b-b573-41e5-85d8-73613b2ffffb.csv', csvSeries: [[displayTableFlag: false, exclusionValues: 'Interfaces,Traits,Classes,Methods,Functions,Constants', file: 'build/logs/phploc.csv', inclusionFlag: 'INCLUDE_BY_STRING', url: '']], group: 'phploc', numBuilds: '100', style: 'line', title: 'BB - Structure Objects', yaxis: 'Count'

      }
    } 
```
    
- A plot menu item will show on the left menu which will show the analytics charts
![Screenshot from 2022-03-07 03-11-19](https://user-images.githubusercontent.com/80127136/157782340-309478b1-bf40-4710-b318-86da0c71bc03.png)
![Screenshot from 2022-03-07 03-11-37](https://user-images.githubusercontent.com/80127136/157782355-b847e6cd-d6d2-41d7-937e-8df9debd7067.png)


    ```
    stage ('Package Artifact') {
    steps {
            sh 'zip -qr php-todo.zip ${WORKSPACE}/*'
     }
    }
    ```

- Bundle the application code into archived package

- Publish the resulted artifact into Artifactory, for this project I used JFrog Cloud Artifactory with will reduce the cost and stress of openning an instance thet will meet artifactory requirement but I added the role to my "ansible-config-mnt" repostitory.
- Configure artifactory in the jenkins UI 
![Screenshot from 2022-03-06 11-32-29](https://user-images.githubusercontent.com/80127136/157781953-0b4dd80d-8863-49c6-860d-a860c20c6480.png)
![Screenshot from 2022-03-07 01-17-25](https://user-images.githubusercontent.com/80127136/157782184-768ffdff-f9f7-4554-a942-03fd4c8825e1.png)
![Screenshot 2022-03-09 052226](https://user-images.githubusercontent.com/80127136/157783871-c2fb4e64-8596-4437-8430-44fcfd06eaef.png)
![Screenshot 2022-03-09 063334](https://user-images.githubusercontent.com/80127136/157784118-fb6715b4-8c02-447d-a121-f1a8685e0c11.png)

- After openning the binary file published to Artifactory
![Screenshot 2022-03-09 095934](https://user-images.githubusercontent.com/80127136/157784351-72a5776f-2f55-4391-9712-7994687782d2.png)


```
stage ('Upload Artifact to Artifactory') {
          steps {
            script { 
                 def server = Artifactory.server 'artifactory-server'                 
                 def uploadSpec = """{
                    "files": [
                      {
                       "pattern": "php-todo.zip",
                       "target": "<name-of-artifact-repository>/php-todo",
                       "props": "type=zip;status=ready"

                       }
                    ]
                 }""" 

                 server.upload spec: uploadSpec
               }
            }

        }


  ```
![Screenshot 2022-03-09 051335](https://user-images.githubusercontent.com/80127136/157783736-040b773c-d9a8-417a-bf41-6ac80d065019.png)
![Screenshot 2022-03-09 051459](https://user-images.githubusercontent.com/80127136/157783748-53fa17ba-9f22-4597-b62a-61b6e35b26c4.png)





- Deploy the application to the dev environment by launching ansible pipeline. This will trigger another jenkins job to run.

```
stage ('Deploy to Dev Environment') {
    steps {
    build job: 'ansible-project/main', parameters: [[$class: 'StringParameterValue', name: 'env', value: 'dev']], propagate: false, wait: true
    }
  }
```

### Installation And Configuration Of SonarQube

- The installation and configuration can be done with SonarQube role which I am currently working on.

- After the installation, sonarqube will run on port 9000.
![Screenshot from 2022-03-07 19-36-37](https://user-images.githubusercontent.com/80127136/157782379-a42264e1-41fe-42f5-9f66-dda40a2d4e4b.png)
![Screenshot from 2022-03-08 06-39-07](https://user-images.githubusercontent.com/80127136/157782579-d13be8cf-9652-4c27-ae00-e983e26c3539.png)

### Configure And Jenkins For Quality Gate

- In Jenkins, install SonarScanner plugin.
![Screenshot 2022-03-09 100051](https://user-images.githubusercontent.com/80127136/157784463-346d9954-45ab-4701-af5b-79009a4182ac.png)

- Navigate to configure system in Jenkins and add SonarQube server as shown below.
![Screenshot from 2022-03-09 22-37-24](https://user-images.githubusercontent.com/80127136/157783098-5a4d5770-f30b-47bc-8345-038629ab87d7.png)

- Generate authentication token in SonarQube. Configure Quality Gate Jenkins Webhook in SonarQube – The URL should point to your Jenkins server "http://{JENKINS_HOST}/sonarqube-webhook/".
![Screenshot from 2022-03-09 12-24-45](https://user-images.githubusercontent.com/80127136/157782647-535ad983-cac0-402a-bde4-46235f427cdb.png)
![Screenshot from 2022-03-09 22-36-00](https://user-images.githubusercontent.com/80127136/157782793-9feaf1dd-8b1f-4f5d-9df0-d151a0988487.png)
![Screenshot from 2022-03-09 22-36-07](https://user-images.githubusercontent.com/80127136/157782812-84f7f58c-b12d-40c7-86b2-2cb1945b6611.png)

- Update Jenkins Pipeline to include SonarQube scanning and Quality Gate with:

```
    stage('SonarQube Quality Gate') {
        environment {
            scannerHome = tool 'SonarQubeScanner'
        }
        steps {
            withSonarQubeEnv('sonarqube') {
                sh "${scannerHome}/bin/sonar-scanner"
            }

        }
    }
```

- After updating and building the Jenkins job it will fail because we have not updated "sonar-scanner.properties"

- Configure sonar-scanner.properties – From the step above, Jenkins will install the scanner tool on the Linux server. You will need to go into the tools directory on the server to configure the properties file in which SonarQube will require to function during pipeline execution in "/var/lib/jenkins/tools/hudson.plugins.sonar.SonarRunnerInstallation/SonarQubeScanner/conf/sonar-scanner.properties".

- Add the following in the sonar-scanner.properties

```
sonar.host.url=http://<SonarQube-Server-IP-address>:9000
sonar.projectKey=php-todo
#----- Default source code encoding
sonar.sourceEncoding=UTF-8
sonar.php.exclusions=**/vendor/**
sonar.php.coverage.reportPaths=build/logs/clover.xml
sonar.php.tests.reportPath=build/logs/junit.xml
```
![Screenshot from 2022-03-09 23-21-40](https://user-images.githubusercontent.com/80127136/157783189-9311bf48-7887-41f0-8ea6-edac23af73e5.png)

![Screenshot from 2022-03-10 11-03-20](https://user-images.githubusercontent.com/80127136/157783032-5d51d6d6-d9cf-4217-b8ec-5db1f793b881.png)


### Conditionally deploy to higher environments

- Replace the SonarQube Quality Gate with:

``` stage('SonarQube Quality Gate') {
      when { branch pattern: "^develop*|^hotfix*|^release*|^main*", comparator: "REGEXP"}
        environment {
            scannerHome = tool 'SonarQubeScanner'
        }
        steps {
            withSonarQubeEnv('sonarqube') {
                sh "${scannerHome}/bin/sonar-scanner -Dproject.settings=sonar-project.properties"
            }
            timeout(time: 1, unit: 'MINUTES') {
                waitForQualityGate abortPipeline: true
            }
        }
    }
```

- After doing all this, the job isn't running as expected it will just be running nonstop when it gets to the "SonarQube Quality Gate" stage so I was able to solve this by scaling-up the server adding slave nodes to the Jenkins.


![Screenshot from 2022-03-10 08-03-41](https://user-images.githubusercontent.com/80127136/157782948-15606871-bb87-44dc-ba94-266b64f46ee7.png)
![Screenshot from 2022-03-10 08-04-18](https://user-images.githubusercontent.com/80127136/157782957-4ccaff03-2c5a-4301-9223-a32d7a9bfad2.png)


![Screenshot from 2022-03-10 08-20-00](https://user-images.githubusercontent.com/80127136/157782979-3c9dbf8d-e6a1-453d-af4b-cd6b12577a4d.png)

![Screenshot from 2022-03-10 08-22-51](https://user-images.githubusercontent.com/80127136/157782992-52f08a38-a829-43c9-937c-eecfffe0f3f1.png)


![Screenshot from 2022-03-10 11-03-20](https://user-images.githubusercontent.com/80127136/157783405-2df575b8-f9f8-4e15-b49f-ecbb7e494182.png)



Thank You

