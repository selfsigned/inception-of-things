GL_OPERATOR_VERSION=0.14.2 # https://gitlab.com/gitlab-org/cloud-native/gitlab-operator/-/releases
PLATFORM=kubernetes

echo "Install cert-manager (gitlab dependency)"
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.10.1/cert-manager.yaml
echo "Wait until cert-manager is ready..."
sleep 8 # can't wait for resources that don't exist yet
kubectl wait --for=condition=Ready pods --all -n cert-manager

echo "Install gitlab Operator"
kubectl create namespace gitlab-system
kubectl apply -f https://gitlab.com/api/v4/projects/18899486/packages/generic/gitlab-operator/${GL_OPERATOR_VERSION}/gitlab-operator-${PLATFORM}-${GL_OPERATOR_VERSION}.yaml
kubectl set env -n gitlab-system deployments/gitlab-controller-manager WATCH_NAMESPACE- #listen on all namespaces

echo "Apply gitlab resource"
kubectl create namespace gitlab
kubectl apply -n gitlab -f ./confs/gitlab.yml
