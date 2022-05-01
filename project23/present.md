# PERSISTING DATA IN KUBERNETES

- Before starting this project I installed **awscl**, then configure it with access_key_id and secret_access_key before creating EKS cluster from aws console.

- Create the kubeconfig file using

```sh
aws eks update-kubeconfig --region <eks_region> --name <eks_name>
```

- Create nginx deployment

```sh
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

- Create an Elastic Block Storage (EBS) in the same region and availability zone as the worker node.

- Copy the volume ID of the newly created volume and update the deployment configuration with the volume spec.

- Apply the new configuration and check the pod. After applying the configuration, I realized that the pod that will be terminated and new pod are in a pending state. This is because the Deployment maxUnavailable is 25% for the rollingUpdate, so I changed it to 1 for it to work properly.

```sh
 strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
```

- Create NodePort service for the node deployment and trying to reach the endpoint, I got a 403 error. This is because mounting a volume on a filesystem that already contains data will automatically erase all the existing data. This strategy for stateful is preferred if the mounted volume already contains the data which you want to be made available to the container.

## MANAGING VOLUMES DYNAMICALLY WITH PVS AND PVCS

- Create a manifest file for a PVC, and based on the gp2 storageClass a PV will be dynamically created.

```sh
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

- Then configure the Pod spec to use the PVC.

```sh
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