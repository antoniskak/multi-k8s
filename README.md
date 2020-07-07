# Description
Example of building a simple multi-container fibonacci calculator app (https://github.com/antoniskak/multi-docker) with Kubernetes and deploying it to GCP.

## Architecture Overview
![Prod_Overview](https://user-images.githubusercontent.com/36962615/86540629-c4be5500-befe-11ea-992f-68abb700236f.png)

## Google Cloud Implementation
![Production_Overview (2)](https://user-images.githubusercontent.com/36962615/86541165-9b9fc380-bf02-11ea-9a3d-714120c743ed.png)

#### Relative Links:
<ul>
  <li>https://github.com/kubernetes/ingress-nginx</li>
  <li>https://kubernetes.github.io/ingress-nginx/deploy/</li>
</ul>

#### Testing locally
```
kubectl apply -f k8s
minikube ip
```
When we visit the ip address the browser will forward to the appropriate port (depending on wether or not an https connection is used) because the service is automatically listening on both ports 80 and 443.

#### Production Deployment to Google Cloud
<ul>
  <li>Create a Kubernetes Cluster with Google Cloud.</li>
  <li>Create a Service Account with an Engine Admin Role.</li>
  <li>Generate a json file "service-account.json" key type.</li>
  <li>Download and install Travis CLI - ruby needs to be installed locally - for Windows we can use a ruby docker image.</li>
 </ul>
 
 ```
  $ docker run -it -v "/$(PWD)":/app ruby:2.4 sh
  # gem install travis
  # travis login --com
```

<ul>
  <li>Copy json file into the 'volumed' directory so it is mounted inside the container.</li>
  <li>Inside the container in the '/app' directory encrypt the json file with "travis encrypt-file" command which will store the secret in a secure variable.</li>
  
  ```
  # travis encrypt-file service-account.json -r antoniskak/multi-k8s --com
  ```
</ul>

&nbsp;&nbsp;&nbsp;&nbsp;This gives us a command to add to the build script (**before_install** stage inside the **.travis.yml** file) and an encrypted file.</br>
&nbsp;&nbsp;&nbsp;&nbsp;**service-account.json.enc** to add to     the git repository. </br>
&nbsp;&nbsp;&nbsp;&nbsp;The original **service-account.json** file must be deleted!!

<ul>
  <li>Configure the GCloud CLI on Cloud Console and create a Secret for pgpassword.</li>  
</ul>

 ```
 $ gcloud config set project <project_id>
 $ gcloud config set compute/zone <region>
 $ gcloud container clusters get-credentials multi-cluster
 $ kubectl create secret generic pgpassword --from-literal PGPASSWORD=<password>
 ```
 
 <ul>
  <li>Install Helm v3 in Google Cloud Console.</li>  
</ul>

 ```
$ curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh
$ chmod 700 get_helm.s
./get_helm.sh
 ```
 
 <ul>
  <li>Install Ingress-Nginx in Google Cloud Console.</li>  
</ul>

 ```
 $ helm repo add stable https://kubernetes-charts.storage.googleapis.com/
 $ helm install my-nginx stable/nginx-ingress --set rbac.create=true
 ```

<ul>
  <li>In Kubernetes Engine > Services and Ingress you should be able to see the nginx-ingress-controller with two different endpoints
  If you visit the port 80 address it will take you to the default backend.</li>
</ul>
<p align="center">
  <img width="757" alt="nginx-ingress-controller" src="https://user-images.githubusercontent.com/36962615/86835770-793daf80-c094-11ea-8c40-b82c57fd466c.PNG">
</p>
<ul>
  <li>In Networking > Network Services > Load Balancing you should be able to see the Google Cloud Load Balancer that was created for the cluster, the ip address that it can be accessed from and the instances (the 3 nodes) that it governs access to.</li>
</ul>

<p align="center">
  <img width="593" alt="GC_Load_Balancer" src="https://user-images.githubusercontent.com/36962615/86834380-b0ab5c80-c092-11ea-92b4-09fe26bacb6a.PNG">
</p>

 <ul>
  <li>Push .travis.yml file to github repo to trigger a build on Travis. Upon successfull deployment:</li>
  <ul>
    <li>The images are pushed to docker hub tagged with both latest commit SHA and latest tags.</li>
    <li>In Kubernetes Engine > Workloads details of each deployment can be found like the pods that each one is managing, their exposing services, CPU, disk and memory usage information etc.</li>
  </ul>
</ul>
<p align="center">
  <img width="755" alt="deployments" src="https://user-images.githubusercontent.com/36962615/86842253-d6d5fa00-c09c-11ea-8546-3222ec4c934b.PNG">
</p>
 <ul>
  <ul>
    <li>In Kubernetes Engine > Services and Ingress all the different ClusterIP services are shown, and the ingress-service with the config of two different routing rules.</li>
  </ul>
</ul>
<p align="center">
  <img width="777" alt="services" src="https://user-images.githubusercontent.com/36962615/86842167-bc9c1c00-c09c-11ea-822d-fafd9a3610e8.PNG">
</p>

 <ul>
  <ul>
    <li>In Kubernetes Engine > Configuration all the different Secrets are shown like the pgpassword.</li>
  </ul>
</ul>
<p align="center">
  <img width="778" alt="secrets" src="https://user-images.githubusercontent.com/36962615/86841931-7050dc00-c09c-11ea-9cd9-bf37c0b3db25.PNG">
</p>


 <ul>
  <ul>
    <li>In Kubernetes Engine > Storage the Persistent Volume Claim is created.</li>
  </ul>
</ul>
<p align="center">
  <img width="488" alt="PVC" src="https://user-images.githubusercontent.com/36962615/86842815-a5116300-c09d-11ea-9b80-d3035329f687.PNG">
</p>

 <ul>
  <ul>
    <li>Visit the external load balancer endpoint ip address to check that the app is working.</li>
  </ul>
</ul>
