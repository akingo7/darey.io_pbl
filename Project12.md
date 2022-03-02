# Project 12 Ansible Refactoring, Assignments and Import

- I created the set-up for Project 11 because I terminate all the instance running after I complete a project.



### Jenkins Job Enhancement

- After creating the set-up for project 11, I created a directory to copy all the artifacts in the jenkins ansible job. Then I change the permission of the file to allow anybody to read, write and execute on the directory so that jenkins will also be able to add to the directory


- Then I install jenkins plugin **Copy Artifact** which will copy to the directory created.


- Then I created the job **save_artifacts**. Configured the job to discard old builds and keep only 2 builds, trigger build if the job ansible finish building and copy the artifacts in the job ansible to "/home/ubuntu/ansible-config-artifact" in the build section.


- Test if the jobs run as expected by adding some texts to the README.md file which build the job ansible and save_artifacts after I commit any change on the repository ansible-config-mgt master branch.

### Refactoring Ansible Code by importing other playbooks into site.yml


- I pulled down the latest changes on the master branch from my vscode then branch out the a new branch **refactor**.


- Within the playbook directory I created new file **site.yml** then move the common.yml to a new directory **static-assignment**.


- In the site.yml file I import common.yml, marge the code with the master branch and run the playbook from my "Jenkins-Ansible Server" then confirm if wireshark is installed on each server as expected.


- Then in the static-assiginments directory I created another playbook **common-del.yml** then configure the deletion of wireshark on each server after that I ssh into each server to confirm if the wireshark is deleted.


- Then I terminated the instance NFS Server, Load Balancer Server and Database Server. Rename the Webserver 1 and 2 to Web1-UAT and Web2-UAT which is the same thing as creating another webserver.

### Configure UAT Webservers with a role 'Webserver'

- Then I created the role structure manually from my vscode.


- Then I update the "ansible-config-mgt/inventory/uat.yml" to update the addressed of the 2 UAT Web servers.


- Uncomment the roles_path to "/home/ubuntu/ansible-config-artifact" so specify where ansible should find the roles.

- Then I wrote configuration task in "ansible-config-mgt/uat-webservers/tasks/main.yml" to do the following:
    - Install and configure Apache (httpd service)
    - Clone tooling repo to "/var/www/html" in each server
    - Ensure that httpd in started


### Reference 'Webserver' role

- Within the static-assiginment directory I created a new file "uat-webservers.yml" and reference the role in it.


- Then I refer my ansible role in the site.yml

### Commit & Test

- This is the point where I got stucked for sometime which is because I wrote the task myself and I was specifying tasks in the task. Secondly I used `ansible.builtin.command` and I realized that I can't run command like that and I had to use `command` module instead of `ansible.builtin.command`. The next is that I wanted to run loop to install httpd and git but I remembered that I can't run loop in static reuse of code but in dynamic reuse of code. Lastly I wanted to use `ansible.builtin.git` to install git which doesn't make sense and it's not like I don't know that I had to use `ansible.builtin.yum` maybe it's because I was sleepy cause I didn't sleep for that night till I completed the project.

- After running the playbook completely, I ssh into each server to check if httpd and git are present then check if the tooling repository content is in "/var/www/html"

Thank You


