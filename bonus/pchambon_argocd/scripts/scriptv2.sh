sed -i 's/wil42\/playground\:v1/wil42\/playground\:v2/g' ./path/wil-deployment.yaml \
&&  git add * \
&& git commit -m  "v2" \
&& git push