echo "[$(hostname)] Installing K3S on agent."
export K3S_TOKEN=$(cat /sync/token)
export INSTALL_K3S_EXEC="agent --server https://192.168.56.110:6643 --node-ip=192.168.56.111"
curl -sfL https://get.k3s.io | sh -
echo "[$(hostname)] Configured succesfully"