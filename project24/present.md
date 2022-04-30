# BUILDING ELASTIC KUBERNETES SERVICE (EKS) WITH TERRAFORM

All the terraform code used in this project can be found [here](infrastructure/).
Click on [screenshots](screenshots/) to see all the screenshots.

![error](screenshots/Screenshot%202022-04-28%20082553.png)
![error](screenshots/Screenshot%202022-04-28%20083056.png)
![error](screenshots/)

- I created [S3 resource](infrastructure/s3bucket.tf) with Terraform apply, then update the terraform block to change the backend.

- Run terraform apply.

![error](screenshots/Screenshot%202022-04-28%20084330.png)
![error](screenshots/Screenshot%202022-04-28%20085241.png)
![error](screenshots/Screenshot%202022-04-28%20092339.png)
![error](screenshots/Screenshot%202022-04-28%20091424.png)
![error](screenshots/Screenshot%202022-04-28%20091516.png)
![error](screenshots/Screenshot%202022-04-28%20091619.png)
![error](screenshots/Screenshot%202022-04-28%20091812.png)
![error](screenshots/Screenshot%202022-04-28%20091907.png)
![error](screenshots/Screenshot%202022-04-28%20092139.png)
![error](screenshots/Screenshot%202022-04-28%20095024.png)

- Install awscli then create the kubeconfig file.

```sh
aws eks --region region update-kubeconfig --name cluster_name
```

![error](screenshots/Screenshot%202022-04-28%20092903.png)

## DEPLOY APPLICATIONS WITH HELM

- Install Helm using snap package manager:

```sh
sudo snap install helm --classic
```

## DEPLOY JENKINS WITH HELM

- Add the repository to helm so that I can easily download and deploy.

```sh
helm repo add jenkins https://charts.jenkins.io
```

- Update helm repository:

```sh
helm repo update
```

![error](screenshots/Screenshot%202022-04-28%20115429.png)
![error](screenshots/Screenshot%202022-04-28%20171221.png)

- Install the chart:

```sh
helm install --set serverType=LoadBalancer jenkins jenkins/jenkins
```

![error](screenshots/Screenshot%202022-04-28%20171655.png)
![error](screenshots/Screenshot%202022-04-28%20171735.png)
![error](screenshots/Screenshot%202022-04-28%20171824.png)

- Check the Helm deployment:

```sh
helm list
```

- Check the pods:

```sh
kubectl get pod jenkins-0 -o wide
```

![error](screenshots/Screenshot%202022-04-28%20175212.png)

- Describe the pod:

```sh
kubectl describe pod jenkins-0
```

![error](screenshots/Screenshot%202022-04-28%20180105.png)
![error](screenshots/Screenshot%202022-04-28%20180214.png)

- Check the logs of the running pod:

```sh
kubectl logs -f jenkins-0 -c jenkins
```

![error](screenshots/Screenshot%202022-04-28%20180554.png)

- Install a package manager for kubectl called krew so that it will enable you to install plugins to extend the functionality of kubectl. Read more about it [Here](https://github.com/kubernetes-sigs/krew)

  - Install the [konfig plugin](https://github.com/corneliusweig/konfig)
  
  ```sh
  kubectl krew install konfig
  ```
  
  - Import the kubeconfig into the default kubeconfig file. Ensure to accept the prompt to overide.
  
  ```sh
  sudo kubectl konfig import --save  [kubeconfig file]
  ```
  
  - Show all the contexts – Meaning all the clusters configured in your kubeconfig. If you have more than 1 Kubernetes clusters configured, you will see them all in the output.
  
  ```sh
  kubectl config get-contexts
  ```

  ![error](screenshots/Screenshot%202022-04-28%20181139.png)
  
  - Set the current context to use for all kubectl and helm commands
  
  ```sh
  kubectl config use-context [name of EKS cluster]
  ```
  
  - Test that it is working without specifying the --kubeconfig flag
  
  ```sh
  kubectl get po
  ```
  
  - Display the current context. This will let you know the context in which you are using to interact with Kubernetes.
  
  ```sh
  kubectl config current-context
  ```

- Access Jenkins UI using the Load Balancer endpoint.

  ![error](screenshots/Screenshot%202022-04-28%20174129.png)
  ![error](screenshots/Screenshot%202022-04-28%20173912.png)
  ![error](screenshots/Screenshot%202022-04-28%20175024.png)
  
  - Get the password to the admin user:
  
  ```sh
  kubectl exec --namespace default -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/chart-admin-password && echo
  ```

  ![error](screenshots/Screenshot%202022-04-28%20174348.png)
  ![error](screenshots/Screenshot%202022-04-28%20174004.png)
  ![error](screenshots/Screenshot%202022-04-28%20174512.png)
  ![error](screenshots/Screenshot%202022-04-28%20174823.png)
  ![error](screenshots/Screenshot%202022-04-28%20175548.png)

## Quick Task

- Using helm to install the following tools

1. [Artifactory](https://artifacthub.io/packages/helm/jfrog/artifactory)
2. [Hashicorp Vault](https://artifacthub.io/packages/helm/hashicorp/vault)
3. [Prometheus](https://artifacthub.io/packages/helm/prometheus-community/prometheus)
4. [Grafana](https://artifacthub.io/packages/helm/grafana/grafana)
5. Elasticsearch ELK using [ECK](https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-install-helm.html)

### Artifactory

![error](screenshots/Screenshot%202022-04-28%20192355.png)
![error](screenshots/Screenshot%202022-04-28%20192758.png)
![error](screenshots/Screenshot%202022-04-28%20193137.png)
![error](screenshots/Screenshot%202022-04-28%20193326.png)
![error](screenshots/Screenshot%202022-04-28%20193914.png)
![error](screenshots/Screenshot%202022-04-28%20195857.png)

### Hashicorp

![error](screenshots/Screenshot%202022-04-29%20000111.png)
![error](screenshots/Screenshot%202022-04-29%20000131.png)
![error](screenshots/Screenshot%202022-04-29%20000436.png)
![error](screenshots/Screenshot%202022-04-29%20005150.png)
![error](screenshots/Screenshot%202022-04-29%20005215.png)
![error](screenshots/Screenshot%202022-04-29%20054859.png)
![error](screenshots/Screenshot%202022-04-29%20055109.png)
![error](screenshots/Screenshot%202022-04-29%20060503.png)
![error](screenshots/Screenshot%202022-04-29%20060703.png)

### Prometheus

![error](screenshots/Screenshot%202022-04-29%20083124.png)
![error](screenshots/Screenshot%202022-04-29%20083124.png)
![error](screenshots/Screenshot%202022-04-29%20084522.png)
![error](screenshots/Screenshot%202022-04-29%20085300.png)
![error](screenshots/Screenshot%202022-04-29%20085835.png)
![error](screenshots/Screenshot%202022-04-29%20090730.png)
![error](screenshots/Screenshot%202022-04-29%20090730.png)

### Grafana

![error](screenshots/Screenshot%202022-04-29%20093306.png)
![error](screenshots/Screenshot%202022-04-29%20093600.png)
![error](screenshots/Screenshot%202022-04-29%20094200.png)
![error](screenshots/Screenshot%202022-04-29%20094348.png)
![error](screenshots/Screenshot%202022-04-29%20094533.png)
![error](screenshots/Screenshot%202022-04-29%20094655.png)

### Elasticsearch ELK using ECK

![error](screenshots/Screenshot%202022-04-29%20113220.png)
![error](screenshots/Screenshot%202022-04-29%20123925.png)
![error](screenshots/Screenshot%202022-04-29%20133653.png)
![error](screenshots/Screenshot%202022-04-29%20134822.png)

- Destroy the infrastructure

![error](screenshots/Screenshot%202022-04-29%20135623.png)

   THANK YOU
