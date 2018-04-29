FROM alpine:edge

RUN echo "https://repository.fit.cvut.cz/mirrors/alpine/edge/main/" > /etc/apk/repositories && \
    echo "https://repository.fit.cvut.cz/mirrors/alpine/edge/community/" >> /etc/apk/repositories && \
    echo "https://repository.fit.cvut.cz/mirrors/alpine/edge/testing/" >> /etc/apk/repositories

RUN apk add --update --no-cache \
    bash='4.4.19-r1' \
    jq='1.6_rc1-r1' \
    terraform='0.11.4-r0' \
    wireguard-tools='0.0.20180420-r3' \
    curl='7.59.0-r1'

# kubectl
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/darwin/amd64/kubectl" && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl

ENTRYPOINT [ "bash", "-c" ]