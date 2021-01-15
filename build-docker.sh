#!/bin/bash

set -e

tag=$1

if [ -z $tag ]; then
  echo "please provide a tag arg"
  exit 1
fi

major=$(echo $tag | awk -F. '{print $1}')
minor=$(echo $tag | awk -F. '{print $2}')

tf_ver="0.14.4"

echo "Confirm building images for:"
echo "  MAJOR: ${major}"
echo "  MINOR: ${minor}"
echo "  TF_VERSION: ${tf_ver}"

read -p "Proceed? [Y/N] " ans

if [[ "$ans" != "Y" && "$ans" != "y" ]]; then
  echo "Cancelling"
  exit 0
fi

set -x
docker build -t piotrjaromin/drone-terraform:latest --build-arg terraform_version=${tf_ver} .

docker tag piotrjaromin/drone-terraform:latest piotrjaromin/drone-terraform:${major}
docker tag piotrjaromin/drone-terraform:latest piotrjaromin/drone-terraform:${major}.${minor}
docker tag piotrjaromin/drone-terraform:latest piotrjaromin/drone-terraform:${major}.${minor}-${tf_ver}

docker push piotrjaromin/drone-terraform:latest
docker push piotrjaromin/drone-terraform:${major}
docker push piotrjaromin/drone-terraform:${major}.${minor}
docker push piotrjaromin/drone-terraform:${major}.${minor}-${tf_ver}
set +x
