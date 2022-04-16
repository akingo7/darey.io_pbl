# MIGRATION TO THE СLOUD WITH CONTAINERIZATION. PART 1

- In this project I use and EC2 instance to run the docker image

- I installed Docker Engine by following [this](https://docs.docker.com/engine/) documentation. Then after the installation I confirmed to see if Docker engine is installed by running `docker -v` which will output the version of the Docker engine installed.

- Pulled the Docker images form Docker Hub Registry. I pulled the latest version of the

- Deploy the MySQL Container to my Docker Engine. Then, check to see if the MySQL container is running.

## CONNECTING TO THE MYSQL DOCKER CONTAINER

- Connecting directly to the container running the MySQL server.

- Connecting to the MySQL server from a second container running the MySQL client utility: Create docker network then attach the network the network to two docker container where one is created with mysql-server image and the other one is created with mysql-client image.

- Create sql file then execute the file in mysql-client container which is connected to mysql-server.

## Prepare database schema

- I cloned the tooling-app repository form [here](https://github.com/darey-devops/tooling).

- Then I used the SQL script in the tooling-app repository to create the database and prepare the schema With the docker exec command.

- Update the db_conn.php file with connection details to the database.

## Run the Tooling App

- I created Dockerfile that will be used to create the tooling-app container. Then I used `docker build -t tooling:0.0.1` to build the image.

- Then I created docker container with.

```sh
docker run --network tooling_app_network -p 8085:80 -it tooling:0.0.1
```

## PRACTICE TASK

- Download php-todo repository [from here](https://github.com/laravel/quickstart-basic)

- Write a Dockerfile for the TODO app and run both database and app on your EC2 instance Docker Engine.

- I created an account in Docker Hub. I am unable to login to Docker Hub from browser but I can login form the CLI.

- Then I pushed the tooling image and php-todo image to Docker Hub from the CLI.

- Then I wrote a Jenkinsfile that will simulate a Docker Build and a Docker Push to the registry. I can't login to my Docker hub account so I didn't install docker plugin which will require my Docker Hub URL.

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

- Update the Jenkinsfile to ensure that the tooling site http endpoint is able to return status code 200. Any other code will be determined a stage failure.

- Thank you.
