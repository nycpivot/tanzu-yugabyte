FROM ubuntu
#https://askubuntu.com/questions/909277/avoiding-user-interaction-with-tzdata-when-installing-certbot-in-a-docker-contai
ENV DEBIAN_FRONTEND=noninteractive


WORKDIR /tmp

COPY data/wl-kubeconfig /tmp/
COPY data/yb-storage.yaml /tmp/
COPY scripts/01-demo-pre-install.sh /tmp
COPY scripts/02-yugabyte-platform-install.sh /tmp
COPY scripts/03-yugabyte-universe-create.sh /tmp
COPY scripts/04-demo-post-universe-install.sh /tmp
COPY scripts/10-database-prereqs.sh /tmp
COPY scripts/11-runtimes-install.sh /tmp
COPY scripts/12-databases-create.sh /tmp
COPY scripts/13-writer-reader-build.sh /tmp
COPY scripts/20-demo-resiliency-test.sh /tmp
COPY scripts/21-writer-run.sh /tmp
COPY scripts/22-reader-run.sh /tmp
COPY scripts/29-yugastore-app-run.sh /tmp
COPY scripts/99-spring-image-run-DELETE.sh /tmp
COPY scripts/99-spring-local-run-DELETE.sh /tmp
COPY scripts/bastion-enabled.sh /tmp
COPY scripts/reset.sh /tmp
COPY scripts/scripts-bootstrapper.sh /tmp
COPY scripts/scripts-downloader.sh /tmp
COPY scripts/tanzu-yugabyte-operator.sh /tmp

COPY vendor/kubectl/kubectl /tmp
RUN install kubectl /usr/local/bin/kubectl 
COPY vendor/helm/linux-amd64/helm /tmp
RUN install helm /usr/local/bin/helm



