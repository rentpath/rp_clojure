FROM amd64/eclipse-temurin:17-jdk-focal

RUN apt-get update
RUN apt-get install -y bash curl git make jq wget unzip nodejs
RUN apt-get clean

## clojure CLI
RUN curl -O https://download.clojure.org/install/linux-install-1.11.1.1155.sh \
&& chmod +x linux-install-1.11.1.1155.sh && ./linux-install-1.11.1.1155.sh

RUN git config --global user.email "rentpath-rprel@rentpath.com"
RUN git config --global user.name "rentpath-rprel"

RUN mkdir -p /root/bin
WORKDIR /root
ENV PATH="/root/bin:${PATH}"
RUN cd /root/bin && curl -LJO https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein && chmod u+x /root/bin/lein

RUN lein

ONBUILD COPY . /root

ONBUILD ARG BUILD_NUMBER
ONBUILD ARG BUILD_ORG_REPO
ONBUILD ARG BUILD_BRANCH
ONBUILD ARG BUILD_SHA
ONBUILD ARG BUILD_TARGET_URL
ONBUILD ARG BUILD_AUTH
ONBUILD ARG VERSION

ONBUILD ENV BUILD_NUMBER=$BUILD_NUMBER \
  BUILD_ORG_REPO=$BUILD_ORG_REPO \
  BUILD_BRANCH=$BUILD_BRANCH \
  BUILD_SHA=$BUILD_SHA \
  BUILD_TARGET_URL=$BUILD_TARGET_URL \
  BUILD_AUTH=$BUILD_AUTH \
  VERSION=$VERSION

ONBUILD RUN echo "version: ${VERSION}\nbuild_number: ${BUILD_NUMBER}\ngit_commit: ${BUILD_SHA}" > resources/BUILD-INFO
