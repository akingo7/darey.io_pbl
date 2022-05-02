# PERSISTING DATA IN KUBERNETES

- Before starting this project I installed **awscl**, then configure it with access_key_id and secret_access_key before creating EKS cluster and node group from aws console.

![error](screenshots/Screenshot%202022-04-30%20163147.png)
![error](screenshots/Screenshot%202022-04-30%20163654.png)
![error](screenshots/Screenshot%202022-04-30%20170520.png)
![error](screenshots/Screenshot%202022-04-30%20181038.png)

- Create the kubeconfig file using

```sh
aws eks update-kubeconfig --region <eks_region> --name <eks_name>
```

![error](screenshots/Screenshot%202022-04-30%20171642.png)

- Create nginx deployment and apply it.

```yaml
apiVersion: apps/v1
kind: Deployment
metadatas:
  name: nginx-deployment
  label:
    tier: frontend
spec:
  replicas: 1
  selector:
    matchLabels:
      tier: frontend
  template:
    metadatas:
      name: nginx
      tier: frontend
    spec:
      containers:
        - name: nginx
          image: nginx:latest
        ports:
        - containerPort: 80
          protocol: TCP
          name:nginx
```

- Verify that the pod is running. Check the logs of the pod

![error](screenshots/Screenshot%202022-05-01%20014646.png)
![error](screenshots/Screenshot%202022-05-01%20015024.png)
![error](screenshots/Screenshot%202022-05-01%20015452.png)

- Exec into the pod and navigate to the nginx configuration file /etc/nginx/conf.d

![error](screenshots/Screenshot%202022-05-01%20015535.png)

- Open the config files to see the default configuration.

![error](screenshots/Screenshot%202022-05-01%20015716.png)
![error](screenshots/Screenshot%202022-05-01%20020406.png)

- Create an Elastic Block Storage (EBS) volume in the same region and availability zone as the worker node.

![error](screenshots/Screenshot%202022-05-01%20020816.png)

- Copy the volume ID of the newly created volume and update the deployment configuration with the volume spec.

- Apply the new configuration and check the pod. After applying the configuration, I realized that the new pod is in pending state and didn't replace one of the pod. This is because the Deployment maxUnavailable is 25% for the rollingUpdate, so I changed it to 1 for it to work properly.

![error](screenshots/Screenshot%202022-05-01%20021659.png)
![error](screenshots/Screenshot%202022-05-01%20021920.png)
![error](screenshots/Screenshot%202022-05-01%20022223.png)
![error](screenshots/Screenshot%202022-05-01%20022223.png)
![error](screenshots/Screenshot%202022-05-01%20024637.png)


```yaml
 strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
```

- Create NodePort service for the node deployment and trying to reach the endpoint.

![error](screenshots/Screenshot%202022-05-01%20025828.png)
![error](screenshots/Screenshot%202022-05-01%20035422.png)

- I got a 403 error. This is because mounting a volume on a filesystem that already contains data will automatically erase all the existing data. This strategy for stateful is preferred if the mounted volume already contains the data which you want to be made available to the container.

## MANAGING VOLUMES DYNAMICALLY WITH PVS AND PVCS

- Create a manifest file for a PVC, and based on the gp2 storageClass a PV will be dynamically created.

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: nginx-volume-claim
spec:
  resources:
    requests:
      storage: 1Gi
  storageClassName: gp2
  accessModes:
    - ReadWriteOnce
```

- Apply the manifest file and Run get on the pvc.

![error](screenshots/Screenshot%202022-05-01%20040615.png)
![error](screenshots/Screenshot%202022-05-01%20040735.png)
![error](screenshots/Screenshot%202022-05-01%20055449.png)

- Then configure the Pod spec to use the PVC.

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
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
  template:
    metadata:
      labels:
        tier: frontend
    spec:
      nodeSelector:
        topology.kubernetes.io/zone: us-east-1a
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
          protocol: TCP
        volumeMounts:
        - name: nginx-volume
          mountPath: /tmp/gabriel/
      volumes:
        - name: nginx-volume
          persistentVolumeClaim:
            claimName: nginx-volume-claim
```

![error](screenshots/Screenshot%202022-05-01%20060627.png)

- Create a statefulset manifest file and run `kubectl apply -f statefulset.yaml`

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: nginx-statefulset
spec:
  selector:
    matchLabels:
      tier: frontend
  serviceName: nginx-service
  replicas: 1
  template:
    metadata:
      labels:
        tier: frontend
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
          name: http
          protocol: TCP
        volumeMounts:
        - name: nginx-volume
          mountPath: /tmp/gabriel

  volumeClaimTemplates:
  - metadata:
      name: nginx-volume
    spec:
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: 1Gi
```

![error](screenshots/Screenshot%202022-05-01%20073203.png)

## CONFIGMAP

- exec into the running container, copy the output and paste it on the config map manifest file.

```sh
kubectl exec -it <pod_name> -- cat /usr/share/nginx/html/index.html
```

![error](screenshots/Screenshot%202022-05-01%20074807.png)

- Persisting configuration data with configMaps

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: website-index-file
data:
  index-file: |
   <!DOCTYPE html>
   <html>
   <head>
   <title>Welcome to nginx!</title>
   <style>
   html { color-scheme: light dark; }
   body { width: 35em; margin: 0 auto;
   font-family: Tahoma, Verdana, Arial, sans-serif; }
   </style
   </head>
   <body>
   <h1>Welcome to nginx!</h1>
   <p>If you see this page, the nginx web server is successfully installed and
   working. Further configuration is required.</p>
   <p>For online documentation and support please refer to
   <a href="http://nginx.org/">nginx.org</a>.<br/>
   Commercial support is available at
   <a href="http://nginx.com/">nginx.com</a>.</p>
   
   <p><em>Thank you for using nginx.</em></p>
   </body>
   </html>
```

- Apply the new manifest file

- Update the statefulset file to use the configmap in the volumeMounts section

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: website-index-file
data:
  index-file: |
   <!DOCTYPE html>
   <html>
   <head>
   <title>Welcome to nginx!</title>
   <style>
   html { color-scheme: light dark; }
   body { width: 35em; margin: 0 auto;
   font-family: Tahoma, Verdana, Arial, sans-serif; }
   </style>
   </head>
   <body>
   <h1>Welcome to nginx!</h1>
   <p>If you see this page, the nginx web server is successfully installed and
   working. Further configuration is required.</p>
   
   <p>For online documentation and support please refer to
   <a href="http://nginx.org/">nginx.org</a>.<br/>
   Commercial support is available at
   <a href="http://nginx.com/">nginx.com</a>.</p>
   
   <p><em>Thank you for using nginx.</em></p>
   </body>
   </html>
   ```

![error](screenshots/Screenshot%202022-05-01%20080207.png)
![error](screenshots/Screenshot%202022-05-01%20080326.png)
![error](screenshots/Screenshot%202022-05-01%20080559.png)

- exec into the pod and list the /usr/share/nginx/html directory

![error](screenshots/Screenshot%202022-05-01%20080725.png)

- Update the configmap

```sh
kubectl edit cm website-index-file
```

![error](screenshots/Screenshot%202022-05-01%20080905.png)
![error](screenshots/Screenshot%202022-05-01%20081107.png)
![error](screenshots/Screenshot%202022-05-01%20081128.png)

- Access the webpage

![error](screenshots/Screenshot%202022-05-01%20081315.png)

THANK YOU