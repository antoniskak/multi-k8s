# Build and tag all images
docker build -t akakafonis/multi-client:latest -t akakafonis/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t akakafonis/multi-server:latest -t akakafonis/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t akakafonis/multi-worker:latest -t akakafonis/multi-worker:$SHA -f ./worker/Dockerfile ./worker

# Push the images to docker hub
docker push akakafonis/multi-client:latest
docker push akakafonis/multi-server:latest
docker push akakafonis/multi-worker:latest

docker push akakafonis/multi-client:$SHA
docker push akakafonis/multi-server:$SHA
docker push akakafonis/multi-worker:$SHA

# Apply all the configs in the k8s directory
# kubectl is installed through gcloud (in .travis.yaml)
kubectl apply -f k8s

# Imperatively set latest images on each deployment
kubectl set image deployments/server-deployment server=akakafonis/multi-server:$SHA
kubectl set image deployments/client-deployment client=akakafonis/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=akakafonis/multi-worker:$SHA