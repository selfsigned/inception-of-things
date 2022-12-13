VAGRANT_USER=vagrant
echo "[$(hostname)] Installing Docker"
apk add --update docker openrc
service docker start
echo "[$(hostname)] Installing K3D on controller."
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
k3d cluster create dev-cluster --port 8080:80@loadbalancer --port 8888:8888@loadbalancer
mkdir -p /home/$VAGRANT_USER/.kube && cp /root/.kube/config /home/$VAGRANT_USER/.kube/config && chown $VAGRANT_USER /home/$VAGRANT_USER/.kube/config
echo "[$(hostname)] Installing Kubectl on controller."
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.25.0/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
sleep 10

####


echo "[$(hostname)] Installing ArgoCD"
wget https://raw.githubusercontent.com/argoproj/argo-cd/master/manifests/install.yaml -O install.yaml
echo "Apply"
kubectl create namespace argocd
kubectl create namespace dev
kubectl apply -f install.yaml -n argocd
kubectl -n argocd set env deployment/argocd-server ARGOCD_SERVER_INSECURE=true
echo "[$(hostname)] Deploying Ingress"
kubectl apply -f /sync/confs/ingress.yaml -n argocd
echo "[$(hostname)] Deploy wils-application"
kubectl apply -f /sync/confs/wilsApp.yaml -n argocd 
echo "[$(hostname)] Wait all pods"
sleep 60
echo "[$(hostname)] Configured succesfully"
echo "Argocd password: $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)"
