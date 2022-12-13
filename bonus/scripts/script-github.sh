cd ../argocd
git init --initial-branch=main
git remote add origin http://gitlab.gitlab.192.168.56.110.nip.io/gitlab-instance-eff4a8fe/pchambon_argocd.git
git add .
git commit -m "Initial commit"
git push -u origin main