FROM hashicorp/vault:latest AS vault
FROM ghcr.io/helmfile/helmfile:latest AS helmfile
FROM alpine:latest
ARG HELM_VERSION

ENV PATH=$PATH:/root/go/bin

COPY --from=vault /bin/vault /bin/
COPY --from=helmfile /usr/local/bin/helmfile /bin/

RUN apk add --no-cache apache2-utils aws-cli bash build-base curl git go jq openssl openssh-client py3-pip python3 sudo wget && \
    pip install --no-cache-dir --break-system-packages jinjanator

RUN curl -fsSL -o get_kubectl.sh https://gitlab.com/cmmarslender/get-kubectl/-/raw/master/get-kubectl.sh && \
    bash get_kubectl.sh

RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
    bash get_helm.sh --version $HELM_VERSION

RUN if [ "$(uname -m)" = "aarch64" ]; then export ARCH="arm64"; else export ARCH="amd64"; fi && \
    wget -q -O /usr/local/bin/k0sctl "https://github.com/k0sproject/k0sctl/releases/latest/download/k0sctl-linux-${ARCH}" && \
    chmod +x /usr/local/bin/k0sctl

RUN LATEST_ISTIO=$(curl -s https://latest.cmm.io/istio) && \
    curl -L https://istio.io/downloadIstio | ISTIO_VERSION=$LATEST_ISTIO sh - && \
    ln -s "/istio-$LATEST_ISTIO/bin/istioctl" /bin/istioctl

RUN if [ "$(uname -m)" = "aarch64" ]; then export ARCH="arm64"; else export ARCH="amd64"; fi && \
    wget -q -O /usr/local/bin/calicoctl "https://github.com/projectcalico/calico/releases/latest/download/calicoctl-linux-${ARCH}" -o calicoctl && \
    chmod +x /usr/local/bin/calicoctl

RUN if [ "$(uname -m)" = "aarch64" ]; then export ARCH="arm64"; else export ARCH="amd64"; fi && \
    CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/main/stable.txt) && \
    curl -L --fail --remote-name-all https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-${ARCH}.tar.gz{,.sha256sum} && \
    sha256sum -c cilium-linux-${ARCH}.tar.gz.sha256sum && \
    tar xzf cilium-linux-${ARCH}.tar.gz && \
    rm -f cilium-linux-${ARCH}.tar.gz && \
    rm -f cilium-linux-${ARCH}.tar.gz.sha256sum && \
    mv ./cilium /usr/local/bin/cilium

RUN go install github.com/google/go-jsonnet/cmd/jsonnet@latest && \
    go install github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb@latest && \
    go install github.com/brancz/gojsontoyaml@latest && \
    go install github.com/mikefarah/yq/v4@latest
