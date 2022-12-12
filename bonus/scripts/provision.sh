echo "->Installing Helm and k3d:"
if [ -f /etc/alpine-release ]; then
	cd /sync
	apk add helm docker openrc
	service docker start
	curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
	curl -L https://storage.googleapis.com/kubernetes-release/release/v1.25.0/bin/linux/amd64/kubectl > /tmp/kubectl
	install /tmp/kubectl /usr/local/bin/kubectl
fi

echo "->creating k3d cluster:"
k3d cluster create bonus \
	--port 2222:22@loadbalancer \
	--port 8080:80@loadbalancer \
	--port 8443:443@loadbalancer \
	--port 8081:8080@loadbalancer \
	--port 8888:8888@loadbalancer

echo "->Installing gitlab:"
kubectl create namespace gitlab
helm repo add gitlab https://charts.gitlab.io/
helm install -n gitlab gitlab gitlab/gitlab \
	--set nginx-ingress.enabled=false \
	--set certmanager.install=false \
	--set global.ingress.configureCertmanager=false

echo "->Installing AgoCD"
kubectl create namespace argocd
kubectl create namespace dev
curl https://raw.githubusercontent.com/argoproj/argo-cd/master/manifests/install.yaml | kubectl apply -n argocd -f -
kubectl -n argocd set env deployment/argocd-server ARGOCD_SERVER_INSECURE=true

echo "->Setup ingress"
kubectl apply -n gitlab -f ./confs/ingress-gitlab.yaml
kubectl apply -n argocd -f ./confs/ingress-argocd.yaml

echo "Argocd password: " $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
