FROM alpine:edge

RUN echo "https://repository.fit.cvut.cz/mirrors/alpine/edge/main/" > /etc/apk/repositories && \
    echo "https://repository.fit.cvut.cz/mirrors/alpine/edge/community/" >> /etc/apk/repositories && \
    echo "https://repository.fit.cvut.cz/mirrors/alpine/edge/testing/" >> /etc/apk/repositories


# hadolint ignore=DL3018
RUN apk add --update --no-cache \
    bash \
    jq \
    terraform \
    wireguard-tools \
    curl 

# kubectl
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/darwin/amd64/kubectl" && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl

ENTRYPOINT [ "bash", "-c" ]