# ANSIBLE DYNAMIC ASSIGNMENTS (INCLUDE) AND COMMUNITY ROLES


### Introducing Dynamic Assignments Into The Structure

- I created a **dynamic_assignments** in the structure and added the file **env-vars.yml**
- Then I created a **env-vars** directory and added the file dev.yml, state.yml, uat.yml and prod.yml into the "env-vars"

- Then add code to the "dynamic_assignments/env-vars.yml" to loop through a the files in the "env-vars" and include the first variable that is found with `ansible.builtin.first_found` module. 

### Update site.yml With Dynamic Assignments

- Then I added this to the site.yml playbook which is the entry point for all the playbooks.

- Then I also found out that the `include` module which is in the documentation is outdated from ansible modules then I replaced it with `import_playbook`

### Downlaod MySQL Ansible Role From Ansible Galaxy

- After that I connected to my Jenkins-Ansible server change to the directory "ansible-config-artifacts".

- Then I check to see if git is installed on the machine with `git --version`.

- After that I initialized git in the directory, added my "ansible-config-mgt" repository as the remote after marging the dynamic-assignment with the master branch.

- Then I pulled the repository master branch then try running the playbook which returned error message then I went to my vscode edited the code push it then marge, move to the jenkins-ansible server pull the latest changes and I was still getting the same error then I repeated the steps few times then later realized the I shouldn't declare the host module when I want to import playbook.

- In the "ansibnle-config-artifacts" I installed mysql ansible role with the command `ansible-galaxy install geerlingguy.mysql` then rename the role directory to "mysql".

- Then I push the changes to my github repository

### Load Balancer Role

- I initialized ansible-galaxy in "AnsibleRole" and "NginxRole" to create the ansible role structure in the "AnsibleRole" and "NginxRole".

- Then I pushed the changes to my repository to create the playbooks in my vscode.


- After creating the code I checked the all to files that I edited to to see if I didn't make any mistake.
- Then I added variable enable_name_lb where name is apache or nginx and load_balancer_required to the default/main.yml of the role, set them to false so that I will be able to choose the webserver to use by setting conditions with them in the dynamic-assignment/loadbalansers.yml where I will import the role.

- Then I pushed the changes to the master branch and pull it from "Jenkins-Ansible server" they try to run it after lauching an instance on AWS to serve as the target.

- Then I run the playbook, ssh into the target host to confirm if truly the webserver enabled to run is there and I opened port 80 in the inbound rule and entered the Public IP on my browser.


Thanl You



