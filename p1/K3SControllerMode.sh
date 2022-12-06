echo "[$(hostname)] Installing K3S on controller."
export INSTALL_K3S_EXEC="--write-kubeconfig-mode=644 --tls-san $(hostname) --node-ip 192.168.56.110 --bind-address=192.168.56.110 --advertise-address=192.168.56.110 "
curl -sfL https://get.k3s.io | sh -
while [ ! -e /var/lib/rancher/k3s/server/token ]
do
    sleep 1
done
sudo cp /var/lib/rancher/k3s/server/token /sync/token
echo "[$(hostname)] Configured succesfully"