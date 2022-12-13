## CREER UN REPO SUR L UI PUBLIC AVEC ROOT PAS LINSTANCE

echo "-> Cloning P3 project in /clone"
mkdir /clone
cd /clone/
git clone https://github.com/Sjorinn/pchambon_argocd.git old_github
echo "-> Copying file to local gitlab"
cp -R ./old_github/scripts ./pchambon_argocd
cp -R ./old_github/path ./pchambon_argocd
cd ./pchambon_argocd
git add .
echo "-> Git commit"
git commit -m "Initial commit"
echo "-> Git push to new repo"
git push
echo "Argocd password: " $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo "Gitlab password: " $(kubectl -n gitlab get secret gitlab-gitlab-initial-root-password -ojsonpath='{.data.password}' | base64 -d ; echo)