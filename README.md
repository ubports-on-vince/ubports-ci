# ci
Use github-actions build ubports


## GITHUB_TOKEN

Follow https://help.github.com/en/actions/configuring-and-managing-workflows/creating-and-storing-encrypted-secrets

# docker

sudo docker build -t ub .
sudo docker run -it --net host -v "$(pwd)":/root -v "$(pwd)":/home/runner --privileged ub

# build.sh
local build scripts
