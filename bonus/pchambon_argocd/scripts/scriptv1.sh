sed -i 's/wil42\/playground\:v2/wil42\/playground\:v1/g' ./path/wil-deployment.yaml \
&&  git add * \
&& git commit -m  "v1" \
&& git push