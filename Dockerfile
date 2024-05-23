FROM hashicorp/vault:latest as vault
FROM alpine:latest
ARG HELM_VERSION

ENV PYENV_ROOT=/root/.pyenv
ENV PATH=$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH:/root/go/bin

COPY --from=vault /bin/vault /bin/

RUN apk add --no-cache apache2-utils bash build-base bzip2-dev curl git go jq libffi-dev openssl openssh-client openssl-dev readline-dev sqlite-dev tk-dev wget xz-dev zlib-dev && \
    if [ "$(uname -m)" = "aarch64" ]; then export ARCH="arm64"; else export ARCH="amd64"; fi && \
    if [ "$(uname -m)" = "aarch64" ]; then export K0SARCH="arm64"; else export K0SARCH="x64"; fi && \
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv && \
    pyenv install 3.11 && \
    pyenv global 3.11 && \
    pip install --upgrade pip && \
    pip install --no-cache-dir j2cli awscli && \
    curl -fsSL -o get_kubectl.sh https://gitlab.com/cmmarslender/get-kubectl/-/raw/master/get-kubectl.sh && \
    bash get_kubectl.sh && \
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
    bash get_helm.sh --version $HELM_VERSION && \
    wget -q -O /usr/local/bin/k0sctl "https://github.com/k0sproject/k0sctl/releases/latest/download/k0sctl-linux-${K0SARCH}" && \
    chmod +x /usr/local/bin/k0sctl && \
    LATEST_ISTIO=$(curl -s https://latest.cmm.io/istio) && \
    curl -L https://istio.io/downloadIstio | ISTIO_VERSION=$LATEST_ISTIO sh - && \
    wget -q -O /usr/local/bin/calicoctl "https://github.com/projectcalico/calico/releases/latest/download/calicoctl-linux-${ARCH}" -o calicoctl && \
    chmod +x /usr/local/bin/calicoctl && \
    ln -s "/istio-$LATEST_ISTIO/bin/istioctl" /bin/istioctl && \
    go install github.com/google/go-jsonnet/cmd/jsonnet@latest && \
    go install github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb@latest && \
    go install github.com/brancz/gojsontoyaml@latest && \
    go install github.com/mikefarah/yq/v4@latest
