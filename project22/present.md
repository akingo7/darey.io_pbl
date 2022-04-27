# DEPLOYING APPLICATIONS INTO KUBERNETES CLUSTER

- In this project I used the steps in project 21 to bootstrap the Kubernetes cluster of one control plane (master node) and two worker nodes.

![Annotation 2022-04-25 211639](https://user-images.githubusercontent.com/80127136/165448882-b8c69468-da1e-4575-bee9-aa590d6eb24f.png)
![Annotation 2022-04-25 220504](https://user-images.githubusercontent.com/80127136/165448957-96f59221-b523-4cb9-b2aa-2aaaaf8ca2cd.png)

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

![Screenshot 2022-04-26 061445](https://user-images.githubusercontent.com/80127136/165448494-c6875fe8-7f71-4cf8-ba49-35ec111bfabc.png)

- To see other fields introduced by kubernetes after you have deployed the resource, simply run below command, and examine the output. You will see other fields that kubernetes updates from time to time to represent the state of the resource within the cluster. -o simply means the output format.

```sh
kubectl get pod -o yaml
# or
kubectl get pod -o json
```
![Screenshot 2022-04-26 062416](https://user-images.githubusercontent.com/80127136/165449390-bb74f4ed-9c72-423c-a34b-095968088968.png)
![Screenshot 2022-04-26 062523](https://user-images.githubusercontent.com/80127136/165449479-2b481c06-6e31-4ee5-884e-0e9176a18052.png)
![Screenshot 2022-04-26 063803](https://user-images.githubusercontent.com/80127136/165449556-77592fe5-69f2-4ec7-9bb5-28b0d9e13e56.png)


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

![Screenshot 2022-04-26 084315](https://user-images.githubusercontent.com/80127136/165449826-d225f76d-e70c-4885-afa5-ea1edd6668a8.png)
![Screenshot 2022-04-26 085421](https://user-images.githubusercontent.com/80127136/165451675-79270e70-d78c-43d1-bd9d-8a47060d139f.png)


- Change the service type to ClusterIP and run kubectl port-forward command
kubectl  port-forward svc/nginx-service 8089:80
![Screenshot 2022-04-26 081358](https://user-images.githubusercontent.com/80127136/165449698-1e4fc071-b572-412c-9a8f-9d31a2b2bd74.png)
![Screenshot 2022-04-26 082419](https://user-images.githubusercontent.com/80127136/165449746-44499cc1-311a-4251-9af9-531f93029520.png)
![Screenshot 2022-04-26 085421](https://user-images.githubusercontent.com/80127136/165450016-e4046309-4b9e-4f03-9615-1cb5e3dfc0e7.png)

![Screenshot 2022-04-26 084853](https://user-images.githubusercontent.com/80127136/165449920-5bb78dfb-2905-4505-b2ea-e2585b86ad7d.png)
![Screenshot 2022-04-26 085806](https://user-images.githubusercontent.com/80127136/165450173-5aa70151-9d21-4ffb-9b68-6eed772c6862.png)

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
![Screenshot 2022-04-26 092334](https://user-images.githubusercontent.com/80127136/165450354-0495a211-97fe-4b58-bfce-30d0dd031de2.png)


- Check what ReplicaSet have been created:

```sh
kubectl get pods
```
![Screenshot 2022-04-26 092410](https://user-images.githubusercontent.com/80127136/165450395-d66fd507-2736-4f75-9c6f-ee37328c370e.png)
![Screenshot 2022-04-26 092953](https://user-images.githubusercontent.com/80127136/165450456-b99dc848-dd00-4c83-b315-f137a327bc9d.png)
![Screenshot 2022-04-26 093147](https://user-images.githubusercontent.com/80127136/165450489-ea926539-f971-4d26-9a5d-b81d69efbda1.png)
![Screenshot 2022-04-26 093350](https://user-images.githubusercontent.com/80127136/165450565-ed8e4304-fce8-4cab-8402-90afb691eb8c.png)
![Screenshot 2022-04-26 093727](https://user-images.githubusercontent.com/80127136/165450588-555e9ce8-8a42-43b6-afe8-6b701778bc53.png)

- Scale ReplicaSet up and down:

  - We can easily scale our ReplicaSet up by specifying the desired number of replicas in an imperative command, like this:

  ```sh
  kubectl scale rs nginx-rs --replicas=5
  ```
![Screenshot 2022-04-26 094025](https://user-images.githubusercontent.com/80127136/165450652-4a7fdf4c-c2e2-4814-91b2-7748a2d1afe9.png)

  - Declarative way would be to open our rs.yaml manifest, change desired number of replicas in the respective section in the file.
  
  ```yaml
  spec:
    replicas: 3
  ```

  - Applying the updated manifest:

  ```sh
   kubectl apply -f rs.yaml
   ```
![Screenshot 2022-04-26 095713](https://user-images.githubusercontent.com/80127136/165450737-72e02f81-d392-4c39-808e-48854031414e.png)

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
![Screenshot 2022-04-26 170756](https://user-images.githubusercontent.com/80127136/165452246-73ca9ce7-f74f-4b25-ac33-1793ea75d34d.png)

![Screenshot 2022-04-26 170756](https://user-images.githubusercontent.com/80127136/165452141-1c6de952-2339-4880-80b9-e46494bfe15d.png)
![Screenshot 2022-04-26 165225](https://user-images.githubusercontent.com/80127136/165451949-b4a0705f-5749-46ca-876b-2ae3e4163263.png)
![Screenshot 2022-04-26 170355](https://user-images.githubusercontent.com/80127136/165451993-a2da3f02-d7ec-448e-b095-cac4f7e5894d.png)
![Screenshot 2022-04-26 170636](https://user-images.githubusercontent.com/80127136/165452022-d701ccb3-5ce0-464e-bd23-79bd39671e0b.png)
![Screenshot 2022-04-26 170923](https://user-images.githubusercontent.com/80127136/165452077-bb771961-b5cb-4ebd-94fb-90359dd907a6.png)

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
![Screenshot 2022-04-26 104831](https://user-images.githubusercontent.com/80127136/165450812-02a79f0f-f94d-4b66-b8c2-8a50470136ff.png)
![Screenshot 2022-04-26 105017](https://user-images.githubusercontent.com/80127136/165450838-dc0ad9b8-f31c-4e98-8ace-fe0b7e589bf3.png)
![Screenshot 2022-04-26 105313](https://user-images.githubusercontent.com/80127136/165450903-f1cffd1e-4b44-417d-89e5-b367648a8a98.png)
![Screenshot 2022-04-26 105430](https://user-images.githubusercontent.com/80127136/165450933-d2cb8b31-81c8-4330-a235-24d02693fb9b.png)

- Exec into one of the Pod’s container to run Linux commands

```sh
kubectl exec -it <POD_NAME> -- bash
```
![Screenshot 2022-04-26 105729](https://user-images.githubusercontent.com/80127136/165451119-d39d665e-cb80-411c-bbff-1f086fcbc0c3.png)

- List the files and folders in the Nginx directory
![Screenshot 2022-04-26 110433](https://user-images.githubusercontent.com/80127136/165451056-2cca21d1-4373-430a-b185-1dbea3d47e5e.png)

- Check the content of the default Nginx configuration file
![Screenshot 2022-04-26 110341](https://user-images.githubusercontent.com/80127136/165451024-cc1d68ca-291f-4dab-a1c9-3ab0ad9eae56.png)

## PERSISTING DATA FOR PODS

- Scale the Pods down to 1 replica.
![Screenshot 2022-04-26 113046](https://user-images.githubusercontent.com/80127136/165451356-41451bd5-a53c-4fbb-ab5a-2c61fb8c1cd7.png)
![Screenshot 2022-04-26 063803](https://user-images.githubusercontent.com/80127136/165451381-d1ba8849-2d12-4757-a65d-6cbd1d7942c5.png)

- Exec into the running container. I can't install vim on the container and I think this is because of the networking in the kubernetes cluster so I used `cat` command to update the code in /usr/share/nginx/html/index.html.

- Update the content of the file and add the code below /usr/share/nginx/html/index.html.
![Screenshot 2022-04-26 114414](https://user-images.githubusercontent.com/80127136/165451415-8192c646-54ac-40d5-8fbd-1174e65936bf.png)
![Screenshot 2022-04-26 114635](https://user-images.githubusercontent.com/80127136/165451463-8d81e0c3-6588-4771-9282-00f0d0306aa9.png)

- Delete the only running Pod.

```sh
 kubectl delete po nginx-deployment-56466d4948-tg9j8
```
![Screenshot 2022-04-26 114916](https://user-images.githubusercontent.com/80127136/165451508-dbce2293-8123-4a92-beb3-f684908043d0.png)
![Screenshot 2022-04-26 114959](https://user-images.githubusercontent.com/80127136/165451540-8aee0a85-ac71-4bab-bf04-a4a94c017937.png)

