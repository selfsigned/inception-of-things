echo "[$(hostname)] Installing K3S on controller."
export INSTALL_K3S_EXEC="--write-kubeconfig-mode=644 --tls-san $(hostname) --node-ip 192.168.56.110 --bind-address=192.168.56.110 --advertise-address=192.168.56.110 "
curl -sfL https://get.k3s.io | sh -
while [ ! -e /var/lib/rancher/k3s/server/token ]
do
    sleep 1
done
sleep 15
echo "[$(hostname)] "
kubectl apply -f /sync/confs/app-1/configmap-1.yaml
kubectl apply -f /sync/confs/app-1/deployment-1.yaml
kubectl apply -f /sync/confs/app-1/service-1.yaml
echo "[$(hostname)] Deploying app-2"
kubectl apply -f /sync/confs/app-2/configmap-2.yaml
kubectl apply -f /sync/confs/app-2/deployment-2.yaml
kubectl apply -f /sync/confs/app-2/service-2.yaml
echo "[$(hostname)] Deploying app-3"
kubectl apply -f /sync/confs/app-3/configmap-3.yaml
kubectl apply -f /sync/confs/app-3/deployment-3.yaml
kubectl apply -f /sync/confs/app-3/service-3.yaml
echo "[$(hostname)] Deploying Ingress"
kubectl apply -f /sync/confs/ingress/ingress.yaml
echo "[$(hostname)] Configured succesfully"
