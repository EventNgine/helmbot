FROM ubuntu:xenial

RUN apt-get update 
RUN apt-get install -y \
    apt-transport-https \
    ca-certificates \
    software-properties-common \
    curl \
    git


#
# Key for kubecli
#
ENV KUBECTL_VER 1.15.10-00 

RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list

RUN apt-get update
RUN apt-get install -y \
   kubectl=${KUBECTL_VER}


#
# Install Helm
#
RUN mkdir /tmp/install
ENV HELM_VER 2.16.1
RUN curl -o /tmp/install/helm-${HELM_VER} https://get.helm.sh/helm-v${HELM_VER}-linux-amd64.tar.gz 
RUN tar -zxvf /tmp/install/helm-* -C /tmp/install/
RUN chmod +x /tmp/install/linux-amd64/helm
RUN mv /tmp/install/linux-amd64/helm /usr/local/bin/helm

RUN useradd -ms /bin/bash helmbot
USER helmbot

RUN helm init --client-only 
RUN helm plugin install https://github.com/databus23/helm-diff --version master

ENTRYPOINT ["/bin/bash", "-c", "--"]
CMD ["while true; do sleep 30; done;"]
