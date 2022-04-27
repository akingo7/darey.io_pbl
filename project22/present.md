# DEPLOYING APPLICATIONS INTO KUBERNETES CLUSTER

- In this project I used the steps in project 21 to bootstrap the Kubernetes cluster of one control plane (master node) and two worker nodes.

- I copied the file **admin.kubeconfig** into **~/.kube/config** so that I will not be adding the kubeconfig file anytime I want to run the `kubectl` command.

## Deploying a random Pod

- Create a Pod yaml manifest on your master node

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  labels:
    app: nginx-pod
spec:
  containers:
    - name: nginx
      image: nginx:latest
      ports:
        - containerPort: 80
          protocol: TCP
  nodeSelector:
    post: st
```

- Apply the manifest with the help of kubectl

```sh
kubectl apply -f nginx-pod.yaml
```

- Get an output of the pods running in the cluster

```sh
kubectl get pod
```

- To see other fields introduced by kubernetes after you have deployed the resource, simply run below command, and examine the output. You will see other fields that kubernetes updates from time to time to represent the state of the resource within the cluster. -o simply means the output format.

```sh
kubectl get pod -o yaml
# or
kubectl get pod -o json
```

## ACCESSING THE APP FROM THE BROWSER

- Using curl to access the container
  - Run kubectl to connect inside the container

```sh
kubectl run curl --image=dareyregistry/curl -i --tty
```

- In order for me to connect to the container I opened port 10250 to the subnet CIDR block.

- Run curl and point to the IP address of the Nginx Pod

```tty
# curl -v 172.32.0.20:80
```

- Create a service to access the Nginx Pod. Creating a ClusterIP service and forwarding the port to access it using `localhost:80` on the browser isn't possible for me to do so I created a NodeIP service instead.

Create a Service yaml manifest file:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    tier: frontend
  type: NodePort
  ports:
   - targetPort: 80
     port: 80
     nodePort: 30000
     protocol: TCP
```

- Create a nginx-service resource by applying the manifest

```sh
kubectl apply -f nginx-service.yaml
```

- Check the created service

```sh
kubectl get service -o wide
```

- Change the service type to ClusterIP and run kubectl port-forward command
kubectl  port-forward svc/nginx-service 8089:80

## CREATE A REPLICA SET

- Create a rs.yaml manifest for a ReplicaSet object:

```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: nginx-rs
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx-pod
  template:
    metadata:
      name: nginx-pod
      labels: 
        app: nginx-pod
        tier: frontend
    spec:
      containers:
        - name: nginx
          image: nginx:latest
          ports:
            - containerPort: 80
              protocol: TCP
```

- Create a nginx-replicaset resource by applying the manifest

```sh
kubectl apply -f rs.yaml
```

- Check what Pods have been created:

```sh
kubectl get pods
```

- Scale ReplicaSet up and down:

  - We can easily scale our ReplicaSet up by specifying the desired number of replicas in an imperative command, like this:

  ```sh
  kubectl scale rs nginx-rs --replicas=5
  ```

  - Declarative way would be to open our rs.yaml manifest, change desired number of replicas in the respective section in the file.
  
  ```yaml
  spec:
    replicas: 3
  ```

  - Applying the updated manifest:

  ```sh
   kubectl apply -f rs.yaml
   ```

  - There is another method – ‘ad-hoc’, it is definitely not the best practice and we do not recommend using it, but you can edit an existing ReplicaSet with following command:

   ```sh
   kubectl edit -f rs.yaml
   ```

## Self Side Task:

- Build the Tooling app Dockerfile and push it to Dockerhub registry.

- Write a Pod and a Service manifests, ensure that you can access the Tooling app’s frontend using port-forwarding feature.

- Tooling-Pod:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: tooling-app
  labels:
    app: tooling-app
spec:
  nodeSelector:
    post: st
  containers:
    - name: tooling
      image: akingo/tooling
      ports:
        - containerPort: 80
          protocol: TCP
```

- Tooling-Service:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: tooling
  labels:
    name: service
spec:
  type: NodePort
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30001
  selector:
    app: tooling-app
```

- Tooling-Database-Pod:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: database
  labels:
    app: database
spec:
   nodeSelector:
     post: st
   containers:
    - name: database
      image: mysql/mysql-server
      ports:
        - containerPort: 3306
          protocol: TCP
      env:
        - name: MYSQLROOTPASSWORD
          value: password

        - name: MYSQL_USER
          value: tooling
    
        - name: MYSQL_DATABASE
          value: toolingdb
        
        - name: MYSQL_PASSWORD
          value: password
```

- Tooling-Database-Service:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: database
spec:
  selector:
      app: database
  ports:
  - port: 3306
```

## USING AWS LOAD BALANCER TO ACCESS YOUR SERVICE IN KUBERNETES

- This can't be done with my setup cause I am not using any of AKS, EKS or GKE.

## USING DEPLOYMENT CONTROLLERS

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    tier: frontend
spec:
  replicas: 1
  selector:
    matchLabels:
      tier: frontend
  template:
    metadata:
      name: nginx-podT
      labels:
        tier: frontend
    spec:
      containers:
        - name: nginx
          image: nginx:latest
          ports:
            - containerPort: 80
              protocol: TCP
```

- Exec into one of the Pod’s container to run Linux commands

```sh
kubectl exec -it <POD_NAME> -- bash
```

- List the files and folders in the Nginx directory

- Check the content of the default Nginx configuration file

## PERSISTING DATA FOR PODS

- Scale the Pods down to 1 replica.

- Exec into the running container. I can't install vim on the container and I think this is because of the networking in the kubernetes cluster so I used `cat` command to update the code in /usr/share/nginx/html/index.html.

- Update the content of the file and add the code below /usr/share/nginx/html/index.html.

- Delete the only running Pod.

```sh
 kubectl delete po nginx-deployment-56466d4948-tg9j8
```
