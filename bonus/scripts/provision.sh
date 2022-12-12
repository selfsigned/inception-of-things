echo "create k3d cluster"
k3d cluster create bonus --port 8081:80@loadbalancer --port 8080:8080@loadbalancer --port 8888:8888@loadbalancer

echo "Setup gitlab"
./scripts/gitlab_operator.sh
