# ANSIBLE DYNAMIC ASSIGNMENTS (INCLUDE) AND COMMUNITY ROLES


### Introducing Dynamic Assignments Into The Structure

- I created a **dynamic_assignments** in the structure and added the file **env-vars.yml**

- Then I created a **env-vars** directory and added the file dev.yml, state.yml, uat.yml and prod.yml into the "env-vars"

![Screenshot from 2022-03-03 00-20-51](https://user-images.githubusercontent.com/80127136/156590276-e79cfc7c-10ee-4816-a4be-7e8736489923.png)



- Then add code to the "dynamic_assignments/env-vars.yml" to loop through a the files in the "env-vars" and include the first variable that is found with `ansible.builtin.first_found` module. 
![Screenshot from 2022-03-03 00-44-22](https://user-images.githubusercontent.com/80127136/156590544-5320453f-fef2-4ff6-91a3-adfb141818f2.png)

### Update site.yml With Dynamic Assignments

- Then I added this to the site.yml playbook which is the entry point for all the playbooks.
![Screenshot from 2022-03-03 00-44-14](https://user-images.githubusercontent.com/80127136/156590790-4fcff3eb-a675-4412-968a-8f69a0805fa4.png)

- Then I also found out that the `include` module which is in the documentation is outdated from ansible modules then I replaced it with `import_playbook`

### Downlaod MySQL Ansible Role From Ansible Galaxy

- After that I connected to my Jenkins-Ansible server change to the directory "ansible-config-artifacts".

- Then I check to see if git is installed on the machine with `git --version`.
![Screenshot from 2022-03-03 06-14-47](https://user-images.githubusercontent.com/80127136/156591822-25bc5d8a-bb56-4a1d-9ac8-85b71f17d221.png)

- After that I initialized git in the directory, added my "ansible-config-mgt" repository as the remote after marging the dynamic-assignment with the master branch.
![Screenshot from 2022-03-03 01-54-18](https://user-images.githubusercontent.com/80127136/156590894-8895b703-50c1-46d6-a88b-51ce34d25991.png)

- Then I pulled the repository master branch then try running the playbook which returned error message then I went to my vscode edited the code push it then marge, move to the jenkins-ansible server pull the latest changes and I was still getting the same error then I repeated the steps few times then later realized the I shouldn't declare the host module when I want to import playbook.
![Screenshot from 2022-03-03 05-39-28](https://user-images.githubusercontent.com/80127136/156591290-54ca6806-d499-4d01-8d00-76142ac97f2d.png)
![Screenshot from 2022-03-03 06-12-55](https://user-images.githubusercontent.com/80127136/156591510-ba1a3680-fc33-4f69-8bca-e5f274e7d68b.png)
![Screenshot from 2022-03-03 06-13-03](https://user-images.githubusercontent.com/80127136/156591743-ce5c7a75-a77e-44d9-8ed3-3f9425d234dd.png)


- In the "ansibnle-config-artifacts" I installed mysql ansible role with the command `ansible-galaxy install geerlingguy.mysql` then rename the role directory to "mysql".
![Screenshot from 2022-03-03 06-16-20](https://user-images.githubusercontent.com/80127136/156592189-f16cce7d-c8cd-445b-81b2-74e0e2fb5869.png)

- Then I push the changes to my github repository
![Screenshot from 2022-03-03 06-21-27](https://user-images.githubusercontent.com/80127136/156592260-3ec8c816-f42b-4e05-88d6-b36a096b5b6d.png)

### Load Balancer Role

- I initialized ansible-galaxy in "AnsibleRole" and "NginxRole" to create the ansible role structure in the "AnsibleRole" and "NginxRole".
![Screenshot from 2022-03-03 06-31-48](https://user-images.githubusercontent.com/80127136/156592341-adecd336-9efa-4f86-b48d-4a53aaf25443.png)
![Screenshot from 2022-03-03 06-33-24](https://user-images.githubusercontent.com/80127136/156592467-71843e44-9690-4898-b0c3-ccc92c51736f.png)

- Then I pushed the changes to my repository to create the playbooks in my vscode.
![Screenshot from 2022-03-03 06-35-59](https://user-images.githubusercontent.com/80127136/156592524-34252430-2308-4e2a-a471-1d66fc4921d6.png)


- After creating the code I checked the all to files that I edited to to see if I didn't make any mistake.
![Screenshot from 2022-03-03 06-54-03](https://user-images.githubusercontent.com/80127136/156592744-a8f788a5-c141-4ba3-a7f6-2ac39eab7862.png)
![Screenshot from 2022-03-03 06-55-41](https://user-images.githubusercontent.com/80127136/156592809-e5d11c25-83c9-4dae-9b32-cc2d162e10d0.png)
![Screenshot from 2022-03-03 06-55-50](https://user-images.githubusercontent.com/80127136/156592828-38318354-9359-4a41-82a1-9a8d314dadd8.png)

![Screenshot from 2022-03-03 07-08-00](https://user-images.githubusercontent.com/80127136/156593070-ffb475b0-adce-4263-9366-59e01039654a.png)

- Then I added variable enable_name_lb where name is apache or nginx and load_balancer_required to the default/main.yml of the role, set them to false so that I will be able to choose the webserver to use by setting conditions with them in the dynamic-assignment/loadbalansers.yml where I will import the role.
![Screenshot from 2022-03-03 06-55-35](https://user-images.githubusercontent.com/80127136/156592792-8c424ef4-df37-4d08-a803-c106995251e8.png)

- Then I pushed the changes to the master branch and pull it from "Jenkins-Ansible server" they try to run it after lauching an instance on AWS to serve as the target.
![Screenshot from 2022-03-03 07-09-34](https://user-images.githubusercontent.com/80127136/156593125-3b183de2-cc55-4f7d-b1ca-ef327e389a2d.png)
![Screenshot from 2022-03-03 07-10-33](https://user-images.githubusercontent.com/80127136/156593155-ebf72c5d-b2ed-4fe8-ae8f-b9faf651c57a.png)
![Screenshot from 2022-03-03 07-14-31](https://user-images.githubusercontent.com/80127136/156593224-247d6b23-9474-4148-8807-9d2603343b64.png)
![Screenshot from 2022-03-03 07-21-28](https://user-images.githubusercontent.com/80127136/156593363-d199cbb7-ead3-4df1-8773-110482bf9ab1.png)
![Screenshot from 2022-03-03 07-29-58](https://user-images.githubusercontent.com/80127136/156593476-f392ad6c-83cc-4194-9593-d4cc130c8f4c.png)
![Screenshot from 2022-03-03 07-33-14](https://user-images.githubusercontent.com/80127136/156593541-281ab08f-e2cc-4073-b5fb-69496164a0a2.png)



- Then I run the playbook, ssh into the target host to confirm if truly the webserver enabled to run is there and I opened port 80 in the inbound rule and entered the Public IP on my browser.
![Screenshot from 2022-03-03 07-34-35](https://user-images.githubusercontent.com/80127136/156593563-6bb709c9-c2b6-4a64-8e36-67f673bd9406.png)
![Screenshot from 2022-03-03 07-37-19](https://user-images.githubusercontent.com/80127136/156593593-ad04c8bc-7dc4-4800-9d9a-a540160ca901.png)

- I was trying to remove this default page but I don't know what I did wrong maybe the handler didn't restart it or what do you think

![Screenshot from 2022-03-03 07-51-56](https://user-images.githubusercontent.com/80127136/156594336-ada1b5f0-b676-4fa6-bbfc-23321caf3914.png)
![Screenshot from 2022-03-03 07-55-06](https://user-images.githubusercontent.com/80127136/156594455-264c8310-6d61-4fa5-a7cc-b4c0def5f4ce.png)

![Screenshot from 2022-03-03 07-39-15](https://user-images.githubusercontent.com/80127136/156593611-7c4d431f-e5a8-4d44-93e6-bc0cc0db0e8b.png)


Thank You.



