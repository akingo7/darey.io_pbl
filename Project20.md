# MIGRATION TO THE СLOUD WITH CONTAINERIZATION. PART 1

- In this project I use and EC2 instance to run the docker image

- I installed Docker Engine by following [this](https://docs.docker.com/engine/) documentation. Then after the installation I confirmed to see if Docker engine is installed by running `docker -v` which will output the version of the Docker engine installed.

![Screenshot 2022-04-12 142337](https://user-images.githubusercontent.com/80127136/163654563-ee4adc9f-e7d4-499a-bfa4-404f49aaebf5.png)
![Screenshot 2022-04-12 143545](https://user-images.githubusercontent.com/80127136/163654641-a5f6baf1-ccf5-4630-ac4b-7b4db579cbdf.png)

- Pulled the Docker images form Docker Hub Registry. I pulled the latest version of the

- Deploy the MySQL Container to my Docker Engine. Then, check to see if the MySQL container is running.

## CONNECTING TO THE MYSQL DOCKER CONTAINER

- Connecting directly to the container running the MySQL server.

![Screenshot 2022-04-12 151206](https://user-images.githubusercontent.com/80127136/163654837-cfdf88ac-c5ea-40ac-b74c-ff6b91641fc7.png)

- Connecting to the MySQL server from a second container running the MySQL client utility: Create docker network then attach the network the network to two docker container where one is created with mysql-server image and the other one is created with mysql-client image.

![Screenshot 2022-04-12 151755](https://user-images.githubusercontent.com/80127136/163654907-102304b8-1d02-4749-80e8-b34d42f7d535.png)
![Screenshot 2022-04-12 152311](https://user-images.githubusercontent.com/80127136/163654919-1db3b89e-12eb-497f-983a-aa51bbddb16f.png)
![Screenshot 2022-04-12 152510](https://user-images.githubusercontent.com/80127136/163654938-1f12810c-93e4-4c0f-8eac-ff5113b2e88f.png)
![Screenshot 2022-04-12 170346](https://user-images.githubusercontent.com/80127136/163654953-7d4e617d-fc97-4268-97b1-bb8872650ffd.png)
![Screenshot 2022-04-12 170504](https://user-images.githubusercontent.com/80127136/163654996-c7d7fac5-a708-44c0-9bdd-a609d712ab3a.png)

- Create sql file then execute the file in mysql-client container which is connected to mysql-server.

## Prepare database schema

- I cloned the tooling-app repository form [here](https://github.com/darey-devops/tooling).

- Then I used the SQL script in the tooling-app repository to create the database and prepare the schema With the docker exec command.

![Screenshot 2022-04-12 173136](https://user-images.githubusercontent.com/80127136/163655043-b133c5be-5670-4969-9c1e-537db4848ddb.png)
![Screenshot 2022-04-12 173538](https://user-images.githubusercontent.com/80127136/163655042-bf37fb6d-4aaa-4f34-b60a-0ed5f6c64736.png)

- Update the .env file with connection details to the database.

## Run the Tooling App

- I created Dockerfile that will be used to create the tooling-app container. Then I used `docker build -t tooling:0.0.1` to build the image.

- Then I created docker container with.

```sh
docker run --network tooling_app_network -p 8085:80 -it tooling:0.0.1
```
![Screenshot 2022-04-13 002435](https://user-images.githubusercontent.com/80127136/163655086-d7ebc251-e250-4a8d-b7cc-6450b0a8cdd4.png)

## PRACTICE TASK

- Download php-todo repository [from here](https://github.com/laravel/quickstart-basic). I launched another instance then create the php-todo app there first before creating the Dockerfile.

![Screenshot 2022-04-13 015532](https://user-images.githubusercontent.com/80127136/163655181-d8793f4a-ff3b-4c49-95ce-24a601647f46.png)

- Write a Dockerfile for the TODO app and run both database and app on your EC2 instance Docker Engine.

![Screenshot 2022-04-14 023827](https://user-images.githubusercontent.com/80127136/163655187-2236b170-9d55-4fad-92b5-452c004b1f37.png)
![Screenshot 2022-04-15 231425](https://user-images.githubusercontent.com/80127136/163655612-c2c276ee-23b8-485f-8854-d557f30ae99b.png)
![Screenshot 2022-04-15 231841](https://user-images.githubusercontent.com/80127136/163655627-a4c4d3e9-1115-4d7f-aeb3-7392906e3cad.png)

- I created an account in Docker Hub. I am unable to login to Docker Hub from browser but I can login form the CLI.

![Screenshot 2022-04-14 055152](https://user-images.githubusercontent.com/80127136/163655294-c1d92913-78c4-40ef-a647-1fbdc6fedbbd.png)

- Then I pushed the tooling image and php-todo image to Docker Hub from the CLI.

![Screenshot 2022-04-14 081249](https://user-images.githubusercontent.com/80127136/163655308-3d5ccf49-5000-46eb-9ddd-eb8c44fb54d3.png)

- I used terraform to create Jenkins Instance and used Ansible to install Ansible, Jenkins,.. on the Jenkins instance created with Terrafrom.

![Screenshot 2022-04-14 104743](https://user-images.githubusercontent.com/80127136/163655485-10bad16f-d20a-4faa-af3d-4aa77b9c54b6.png)
![Screenshot 2022-04-14 110102](https://user-images.githubusercontent.com/80127136/163655488-0dae4322-45fd-490c-bacf-542ed13abda5.png)
![Screenshot 2022-04-14 110419](https://user-images.githubusercontent.com/80127136/163655494-e2b71e11-5750-4c4d-a019-c075c577deea.png)

- Then I wrote a Jenkinsfile that will simulate a Docker Build and a Docker Push to the registry. I can't login to my Docker hub account so I didn't install docker plugin which will require my Docker Hub URL. I run `docker login` with Jenkins user to login to docker.

![Screenshot 2022-04-14 111311](https://user-images.githubusercontent.com/80127136/163655533-1cb75022-fbe4-4c0e-b2b0-b3b2067463fe.png)
![Screenshot 2022-04-14 121106](https://user-images.githubusercontent.com/80127136/163655579-c9b35982-e3d1-4fc8-ae08-91985621e3b3.png)

## Deployment with Docker Compose

- I installed Docker Compose on my workstation from using [this](https://docs.docker.com/compose/install/) documentation. Then I checked the version of the Docker-compose installed with `docker-compose -v`.

- Created a file "tooling.yaml" the paste the code below into it.

```yaml
version: "3.9"
services:
  tooling_frontend:
    build: .
    ports:
      - "5000:80"
    volumes:
      - tooling_frontend:/var/www/html
    links:
      - db
  db:
    image: mysql:5.7
    restart: always
    environment:
      MYSQL_DATABASE: <The database name required by Tooling app >
      MYSQL_USER: <The user required by Tooling app >
      MYSQL_PASSWORD: <The password required by Tooling app >
      MYSQL_RANDOM_ROOT_PASSWORD: '1'
    volumes:
      - db:/var/lib/mysql
volumes:
  tooling_frontend:
  db:
```

The "version" is used to specify the version of Docker-compose I want to use which is version 3.9.
The "services" is for each the container I want to create.
"build", to add the path to the Dockerfile for the tooling-container.
"ports", The port I want to expose from the container.
"volume", to mount the volume created to path in the container.
"links" so that the tooling-container will be created after the db-container.
"images" which is in the db session to add the docker image to pull from docker registry to build the db container.
"environment", for the variables to use when creating database and database user.
"volumes" to create the volume I am mounting on to the container.

- Then I run the command to start the container:

```sh
docker-compose -f tooling.yaml  up -d 
```

![Screenshot 2022-04-14 101518](https://user-images.githubusercontent.com/80127136/163655332-8fd70d9a-75ae-41d0-acef-5755ff1d5fee.png)

- Update the Jenkinsfile to ensure that the tooling site http endpoint is able to return status code 200. Any other code will be determined a stage failure.
![Screenshot 2022-04-14 140708](https://user-images.githubusercontent.com/80127136/163655597-8317d2f5-a329-4705-865d-3e32286eb64f.png)

- Thank you.
