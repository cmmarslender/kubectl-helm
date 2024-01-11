FROM alpine:latest
ARG HELM_VERSION

ENV PATH=$PATH:/root/go/bin

RUN apk add --no-cache apache2-utils curl wget python3 py-pip bash openssl jq go git && \
    if [ "$(uname -m)" = "aarch64" ]; then export K0SARCH="arm64"; else export K0SARCH="x64"; fi && \
    pip3 install --break-system-packages j2cli awscli && \
    curl -fsSL -o get_kubectl.sh https://gitlab.com/cmmarslender/get-kubectl/-/raw/master/get-kubectl.sh && \
    bash get_kubectl.sh && \
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
    bash get_helm.sh --version $HELM_VERSION && \
    wget -q -O /usr/local/bin/k0sctl "https://github.com/k0sproject/k0sctl/releases/latest/download/k0sctl-linux-${K0SARCH}" && \
    chmod +x /usr/local/bin/k0sctl && \
    go install github.com/google/go-jsonnet/cmd/jsonnet@latest && \
    go install github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb@latest && \
    go install github.com/brancz/gojsontoyaml@latest && \
    go install github.com/mikefarah/yq/v4@latest
