FROM alpine:latest
ARG HELM_VERSION

RUN apk add --no-cache curl python3 py-pip bash openssl && \
    pip3 install j2cli awscli && \
    curl -fsSL -o get_kubectl.sh https://gitlab.com/cmmarslender/get-kubectl/-/raw/master/get-kubectl.sh && \
    bash get_kubectl.sh && \
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
    bash get_helm.sh --version $HELM_VERSION
