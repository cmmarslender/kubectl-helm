# Kubectl Helm

Docker image with kubectl and helm preinstalled. Supports both amd64 and arm64

Image always has latest kubectl from build time and specified version of helm

Alpine Based:

`ghcr.io/cmmarslender/kubectl-helm:$HELM_VERSION`

Debian Based: 

`ghcr.io/cmmarslender/kubectl-helm:$HELM_VERSION-debian`

Available tags can be [referenced here](https://github.com/cmmarslender/kubectl-helm/pkgs/container/kubectl-helm)


## GitLab Images

This project used to live in gitlab, and for continuity of any workflows using the gitlab container registry urls, the following images will be maintained for now.

Alpine Based:

`registry.gitlab.com/cmmarslender/kubectl-helm:$HELM_VERSION`

Debian Based:

`registry.gitlab.com/cmmarslender/kubectl-helm:$HELM_VERSION-debian`
