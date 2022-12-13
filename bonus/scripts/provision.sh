echo "->Installing Helm and k3d:"
if [ -f /etc/alpine-release ]; then
	cd /sync
	apk add helm docker openrc
	apk add git
	service docker start
	curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
	curl -L https://storage.googleapis.com/kubernetes-release/release/v1.25.0/bin/linux/amd64/kubectl > /tmp/kubectl
	install /tmp/kubectl /usr/local/bin/kubectl
fi

echo "->creating k3d cluster:"
k3d cluster create bonus \
	--port 8080:80@loadbalancer \
	--port 8888:8888@loadbalancer

if [ -f /etc/alpine-release ]; then
	VAGRANT_USER=vagrant
	echo "->Copying k3d credentials to vagrant user"
	mkdir -p /home/$VAGRANT_USER/.kube && cp /root/.kube/config /home/$VAGRANT_USER/.kube/config && chown $VAGRANT_USER /home/$VAGRANT_USER/.kube/config
fi

echo "->Installing gitlab:"
kubectl create namespace gitlab
helm repo add gitlab https://charts.gitlab.io/
helm install -n gitlab gitlab gitlab/gitlab \
	-f ./confs/gitlab-minimum.yaml

echo "->Installing AgoCD"
kubectl create namespace argocd
kubectl create namespace dev
curl https://raw.githubusercontent.com/argoproj/argo-cd/master/manifests/install.yaml | kubectl apply -n argocd -f -
kubectl -n argocd set env deployment/argocd-server ARGOCD_SERVER_INSECURE=true

echo "->Setup ingress and wilsApps"
kubectl apply -n argocd -f ./confs/ingress-argocd.yaml
kubectl apply -n gitlab -f ./confs/ingress-gitlab.yaml

echo "->Wait for gitlab to be ready"
sudo kubectl wait --for=condition=complete -n gitlab --timeout=600s job/gitlab-migrations-1
echo "Argocd password: " $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo "Gitlab password: " $(kubectl -n gitlab get secret gitlab-gitlab-initial-root-password -ojsonpath='{.data.password}' | base64 -d ; echo)

echo \
" ----> Commandes suivantes : Create first repo with the UI
cd /sync
git clone https://github.com/Sjorinn/pchambon_argocd.git pchambon_argocd
cd pchambon_argocd
git remote set-url origin http://gitlab.192.168.56.110.nip.io:8080/root/pchambon_argocd.git
---> don't forget to apply wilsapp after creating and updating the repo
kubectl apply -n argocd -f /sync/confs/wilsApp.yaml
Argocd password: $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
Gitlab password: $(kubectl -n gitlab get secret gitlab-gitlab-initial-root-password -ojsonpath='{.data.password}' | base64 -d ; echo)" 