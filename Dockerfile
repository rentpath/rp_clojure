FROM adoptopenjdk:8u252-b09-jre-openj9-0.20.0-bionic

RUN apt-get update
RUN apt-get install -y bash curl git make jq wget unzip
RUN apt-get clean

## clojure CLI
RUN curl -O https://download.clojure.org/install/linux-install-1.10.1.536.sh \
&& chmod +x linux-install-1.10.1.536.sh && ./linux-install-1.10.1.536.sh

RUN git config --global user.email "rentpath-rprel@rentpath.com"
RUN git config --global user.name "rentpath-rprel"

RUN mkdir -p /root/bin
WORKDIR /root
ENV PATH="/root/bin:${PATH}"
RUN cd /root/bin && curl -LJO https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein && chmod u+x /root/bin/lein

RUN lein

ONBUILD COPY . /root

ONBUILD ARG BUILD_ORG_REPO
ONBUILD ARG BUILD_AUTH
ONBUILD ARG BUILD_BRANCH
ONBUILD ARG BUILD_SHA
ONBUILD ARG BUILD_NUMBER
ONBUILD ARG BUILD_TARGET_URL
ONBUILD ARG NEXUS_USERNAME
ONBUILD ARG NEXUS_PASSWORD

ONBUILD ENV BUILD_NUMBER=$BUILD_NUMBER \
  BUILD_BRANCH=$BUILD_BRANCH \
  BUILD_SHA=$BUILD_SHA \
  BUILD_ORG_REPO=$BUILD_ORG_REPO \
  BUILD_TARGET_URL=$BUILD_TARGET_URL \
  BUILD_AUTH=$BUILD_AUTH \
  NEXUS_USERNAME=$NEXUS_USERNAME \
  NEXUS_PASSWORD=$NEXUS_PASSWORD

ONBUILD RUN echo "options ndots:3" >> /etc/resolv.conf
