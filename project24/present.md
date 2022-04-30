# BUILDING ELASTIC KUBERNETES SERVICE (EKS) WITH TERRAFORM

All the terraform code used in this project can be found [here](infrastructure/).

- I created [S3 resource](infrastructure/s3bucket.tf) with Terraform apply, then update the terraform block to change the backend.

- Run terraform apply. Install awscli then create the kubeconfig file.

```sh
aws eks --region region update-kubeconfig --name cluster_name
```

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

- Install the chart:

```sh
helm install --set serverType=LoadBalancer jenkins jenkins/jenkins
```

- Check the Helm deployment:

```sh
helm list
```

- Check the pods:

```sh
kubectl get pod jenkins-0 -o wide
```

- Describe the pod:

```sh
kubectl describe pod jenkins-0
```

- Check the logs of the running pod:

```sh
kubectl logs -f jenkins-0 -c jenkins
```

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
  
  - Get the password to the admin user:
  
  ```sh
  kubectl exec --namespace default -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/chart-admin-password && echo
  ```

## Quick Task

- Using helm to install the following tools

1. [Artifactory](https://artifacthub.io/packages/helm/jfrog/artifactory)
2. [Hashicorp Vault](https://artifacthub.io/packages/helm/hashicorp/vault)
3. [Prometheus](https://artifacthub.io/packages/helm/prometheus-community/prometheus)
4. [Grafana](https://artifacthub.io/packages/helm/grafana/grafana)
5. Elasticsearch ELK using [ECK](https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-install-helm.html)

### Artifactory

### Hashicorp

### Prometheus

### Grafana

### Elasticsearch ELK using ECK