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
  <li>Create a Kubernetes Cluster with Google Cloud</li>
  <li>Create a Service Account with an Engine Admin Role</li>
  <li>Generate a json file "service-account.json" key type</li>
  <li>Download and install Travis CLI - ruby needs to be installed locally - for Windows we can use a ruby docker image</li>
 </ul>
 
 ```
  $ docker run -it -v "/$(PWD)":/app ruby:2.4 sh
  # gem install travis
  # travis login --com
```

<ul>
  <li>Copy json file into the 'volumed' directory so it is mounted inside the container</li>
  <li>Inside the container in the '/app' directory encrypt the json file with "travis encrypt-file" command which will store the secret in a secure variable</li>
  
  ```
  # travis encrypt-file service-account.json -r antoniskak/multi-k8s --com
  ```
</ul>

This gives us a command to add to the build script (**before_install** stage inside the **.travis.yml** file) and an encrypted file **service-account.json.enc** to add to the git repository. 

The original **service-account.json** file must be deleted!!
