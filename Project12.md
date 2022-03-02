# Project 12 Ansible Refactoring, Assignments and Import

- I created the set-up for Project 11 because I terminate all the instance running after I complete a project.
![Screenshot from 2022-03-02 00-23-21](https://user-images.githubusercontent.com/80127136/156371166-a35408a3-3e17-4ce2-9447-a1cacb151035.png)
![Screenshot from 2022-03-02 00-26-07](https://user-images.githubusercontent.com/80127136/156371176-605d244e-0439-47de-8afa-bce2c8cf0fd0.png)
![Screenshot from 2022-03-02 00-27-30](https://user-images.githubusercontent.com/80127136/156371186-55b20234-aaac-4a7c-a9ba-182a81542393.png)
![Screenshot from 2022-03-02 00-31-09](https://user-images.githubusercontent.com/80127136/156371205-a605358c-9f2d-431c-9875-11f4abe44d2b.png)
![Screenshot from 2022-03-02 00-32-29](https://user-images.githubusercontent.com/80127136/156371220-7e583682-b14c-419c-a8e8-ca22a91cf844.png)



### Jenkins Job Enhancement

- After creating the set-up for project 11, I created a directory to copy all the artifacts in the jenkins ansible job. Then I change the permission of the file to allow anybody to read, write and execute on the directory so that jenkins will also be able to add to the directory
![Screenshot from 2022-03-02 00-50-49](https://user-images.githubusercontent.com/80127136/156371244-df177198-7d11-4f07-a3b7-7bd1d27c9d60.png)


- Then I install jenkins plugin **Copy Artifact** which will copy to the directory created.
![Screenshot from 2022-03-02 00-42-58](https://user-images.githubusercontent.com/80127136/156371274-64b16cb2-e890-4308-b88b-c661368b1ff7.png)


- Then I created the job **save_artifacts**. Configured the job to discard old builds and keep only 2 builds, trigger build if the job ansible finish building and copy the artifacts in the job ansible to "/home/ubuntu/ansible-config-artifact" in the build section.
![Screenshot from 2022-03-02 00-53-21](https://user-images.githubusercontent.com/80127136/156371339-9973411d-313f-4590-88d7-5dbcaec90738.png)
![Screenshot from 2022-03-02 00-58-31](https://user-images.githubusercontent.com/80127136/156371373-809a2651-14d3-4b8d-b339-10d19b7b1515.png)
![Screenshot from 2022-03-02 00-58-42](https://user-images.githubusercontent.com/80127136/156371385-0bb046fb-2571-45e5-b458-c67f02a6ab53.png)
![Screenshot from 2022-03-02 00-58-58](https://user-images.githubusercontent.com/80127136/156371398-b53319d1-0e53-4bf3-b2b3-2138619cb95f.png)


- Test if the jobs run as expected by adding some texts to the README.md file which build the job ansible and save_artifacts after I commit any change on the repository ansible-config-mgt master branch.

![Screenshot from 2022-03-02 01-05-16](https://user-images.githubusercontent.com/80127136/156371574-88cde2ae-99ce-4d84-998e-245241ad782d.png)

![Screenshot from 2022-03-02 01-05-37](https://user-images.githubusercontent.com/80127136/156371462-d7a71061-226e-440f-80b1-0afacb80362a.png)

### Refactoring Ansible Code by importing other playbooks into site.yml


- I pulled down the latest changes on the master branch from my vscode then branch out the a new branch **refactor**.
![Screenshot from 2022-03-02 01-08-55](https://user-images.githubusercontent.com/80127136/156371590-0b75ffce-75a9-4701-b9fd-9133b1ad8924.png)


- Within the playbook directory I created new file **site.yml** then move the common.yml to a new directory **static-assignment**.
![Screenshot from 2022-03-02 01-18-36](https://user-images.githubusercontent.com/80127136/156371612-4306d262-3b41-4e05-a29e-02a343543ca5.png)


- In the site.yml file I import common.yml, marge the code with the master branch and run the playbook from my "Jenkins-Ansible Server" then confirm if wireshark is installed on each server as expected.
![Screenshot from 2022-03-02 01-18-43](https://user-images.githubusercontent.com/80127136/156371639-d61ddc3b-9342-4941-a693-613a2805d03b.png)
![Screenshot from 2022-03-02 01-41-09](https://user-images.githubusercontent.com/80127136/156372029-febb43e3-4d16-41d7-a666-5e417e4964df.png)
![Screenshot from 2022-03-02 01-45-43](https://user-images.githubusercontent.com/80127136/156372269-211e228a-a8e4-4887-805a-662449d641dd.png)

- Then I logout of the Jenkins-Ansible Server because I don't have my private key there so I had to use SSH-Agent
![Screenshot from 2022-03-02 01-26-55](https://user-images.githubusercontent.com/80127136/156371823-3bbc2aba-3552-4eec-982d-e14c18420a8c.png)

- Then in the static-assiginments directory I created another playbook **common-del.yml** then configure the deletion of wireshark on each server after that I ssh into each server to confirm if the wireshark is deleted.
![Screenshot from 2022-03-02 02-01-17](https://user-images.githubusercontent.com/80127136/156372131-b4f09831-4a5d-4118-b17c-49ecdedcac87.png)
![Screenshot from 2022-03-02 02-10-44](https://user-images.githubusercontent.com/80127136/156372156-46801a9b-cca1-4365-a90f-2a8179623c84.png)
![Screenshot from 2022-03-02 02-12-36](https://user-images.githubusercontent.com/80127136/156372401-f31373f2-6a8d-4a1b-8b3c-b09b83e5e87f.png)


- Then I terminated the instance NFS Server, Load Balancer Server and Database Server. Rename the Webserver 1 and 2 to Web1-UAT and Web2-UAT which is the same thing as creating another webserver.
![Screenshot from 2022-03-02 02-17-46](https://user-images.githubusercontent.com/80127136/156372496-11a2b45e-bacf-40b8-a240-8727157723a5.png)

### Configure UAT Webservers with a role 'Webserver'

- Then I created the role structure manually from my vscode.
![Screenshot from 2022-03-02 02-31-15](https://user-images.githubusercontent.com/80127136/156372529-d446e979-43ba-4b69-bb0b-2fb44b9803e6.png)


- Then I update the "ansible-config-mgt/inventory/uat.yml" to update the addressed of the 2 UAT Web servers.
![Screenshot from 2022-03-02 02-35-10](https://user-images.githubusercontent.com/80127136/156372558-8f50db9a-571c-49aa-ae01-122c7e906846.png)


- Uncomment the roles_path to "/home/ubuntu/ansible-config-artifact" so specify where ansible should find the roles.
![Screenshot from 2022-03-02 02-41-14](https://user-images.githubusercontent.com/80127136/156372682-e86fc81b-0e1a-4f7d-87ec-0b04cba6c5ce.png)

- Then I wrote configuration task in "ansible-config-mgt/uat-webservers/tasks/main.yml" to do the following:
    - Install and configure Apache (httpd service)
    - Clone tooling repo to "/var/www/html" in each server
    - Ensure that httpd in started
![Screenshot from 2022-03-02 02-57-21](https://user-images.githubusercontent.com/80127136/156372711-92d35c08-b4a7-4911-8247-6847acd5fef9.png)
![Screenshot from 2022-03-02 03-03-33](https://user-images.githubusercontent.com/80127136/156372724-54a2dbe3-899e-47c4-8edc-be9079f342bd.png)
![Screenshot from 2022-03-02 03-13-53](https://user-images.githubusercontent.com/80127136/156372778-c1c5543f-b87d-4984-9e99-45ec154b1e8f.png)


### Reference 'Webserver' role

- Within the static-assiginment directory I created a new file "uat-webservers.yml" and reference the role in it.
![Screenshot from 2022-03-02 03-13-53](https://user-images.githubusercontent.com/80127136/156372911-370aaf15-fef2-4ced-9ec3-5c27d0edff19.png)
![Screenshot from 2022-03-02 03-20-30](https://user-images.githubusercontent.com/80127136/156373018-41a6ed54-e88c-42fb-b17f-bff37c52651d.png)


- Then I refer my ansible role in the site.yml
![Screenshot from 2022-03-02 03-19-54](https://user-images.githubusercontent.com/80127136/156372994-10b0ce55-4b31-46ed-b0dd-7c85490f1182.png)

### Commit & Test

- This is the point where I got stucked for sometime which is because I wrote the task myself and I was specifying tasks in the task. Secondly I used `ansible.builtin.command` and I realized that I can't run command like that and I had to use `command` module instead of `ansible.builtin.command`. The next is that I wanted to run loop to install httpd and git but I remembered that I can't run loop in static reuse of code but in dynamic reuse of code. Lastly I wanted to use `ansible.builtin.git` to install git which doesn't make sense and it's not like I don't know that I had to use `ansible.builtin.yum` maybe it's because I was sleepy cause I didn't sleep for that night till I completed the project.
![Screenshot from 2022-03-02 03-29-17](https://user-images.githubusercontent.com/80127136/156373075-64b3e1e9-3d48-4def-ba8c-712196d21936.png)
![Screenshot from 2022-03-02 03-30-42](https://user-images.githubusercontent.com/80127136/156373094-b3d2acfe-b64c-4617-a4f4-38fb4cc8f72f.png)
![Screenshot from 2022-03-02 03-32-50](https://user-images.githubusercontent.com/80127136/156373114-0aecae86-4ff9-4dc0-a900-a72f73207892.png)
![Screenshot from 2022-03-02 04-29-49](https://user-images.githubusercontent.com/80127136/156373204-eb7ff6fe-8687-4f03-8362-6b0e64bf6fda.png)
![Screenshot from 2022-03-02 04-33-54](https://user-images.githubusercontent.com/80127136/156373242-2fdc8802-b1a3-4dad-8a5b-862e65d47b06.png)
![Screenshot from 2022-03-02 05-19-10](https://user-images.githubusercontent.com/80127136/156373279-b614e905-a7f1-46b4-809d-c1bc4acb3755.png)
![Screenshot from 2022-03-02 05-20-52](https://user-images.githubusercontent.com/80127136/156373326-d0565a56-c79b-457c-8a1d-fde323f46e9f.png)

- After running the playbook completely, I ssh into each server to check if httpd and git are present then check if the tooling repository content is in "/var/www/html"
![Screenshot from 2022-03-02 05-38-51](https://user-images.githubusercontent.com/80127136/156373421-927e36d9-6c65-475c-9cf0-c37b79f58394.png)
![Screenshot from 2022-03-02 05-39-01](https://user-images.githubusercontent.com/80127136/156373442-6e4cac7b-1f0c-4c2c-b0f1-71304efede7b.png)
![Screenshot from 2022-03-02 05-39-11](https://user-images.githubusercontent.com/80127136/156373463-81f27332-3d31-4dd8-8e18-ded52e87a9e7.png)
![Screenshot from 2022-03-02 05-42-10](https://user-images.githubusercontent.com/80127136/156373579-3f638fd4-c904-4188-9231-abef824e20a0.png)

Thank You


