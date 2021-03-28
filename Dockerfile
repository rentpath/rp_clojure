FROM adoptopenjdk/openjdk8:jdk8u282-b08-slim

RUN apt-get update
RUN apt-get install -y bash curl wget git
RUN apt-get clean

WORKDIR /root
RUN wget https://downloads.apache.org/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
RUN tar -xvzf apache-maven-3.6.3-bin.tar.gz
COPY ./mvn-build /root/bin/mvn-build
COPY ./mvn-release /root/bin/mvn-release
RUN chmod u+x /root/bin/mvn-build
RUN chmod u+x /root/bin/mvn-release
ENV PATH="/root/bin:/root/apache-maven-3.6.3/bin:${PATH}"

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
