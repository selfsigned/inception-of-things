echo "[$(hostname)] Installing K3D on controller."
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
echo "[$(hostname)] Installing ArgoCD"
kubectl create namespace argocd
kubectl create namespace dev
wget https://raw.githubusercontent.com/argoproj/argo-cd/master/manifests/install.yaml -O install.yaml
kubectl apply -f install.yaml -n argocd
echo "[$(hostname)] Installing Docker"
apk add --update docker openrc
echo "[$(hostname)] Deploying Ingress"
kubectl apply -f /sync/ingress/ingress.yaml
echo "[$(hostname)] Configured succesfully"
