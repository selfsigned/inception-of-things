echo "[$(hostname)] Installing Docker"
apk add --update docker openrc
service docker start
echo "[$(hostname)] Installing K3D on controller."
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
k3d cluster create dev-cluster --port 8080:80@loadbalancer --port 8888:8888@loadbalancer --port 8443:443@loadbalancer
echo "[$(hostname)] Installing Kubectl on controller."
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.25.0/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
sleep 15
echo "[$(hostname)] Installing ArgoCD"
kubectl create namespace argocd
kubectl create namespace dev
wget https://raw.githubusercontent.com/argoproj/argo-cd/master/manifests/install.yaml -O install.yaml
echo "Apply"
kubectl apply -f install.yaml -n argocd
echo "[$(hostname)] Deploying Ingress"
kubectl apply -f /sync/yaml/ingress.yaml
echo "[$(hostname)] Configured succesfully"
