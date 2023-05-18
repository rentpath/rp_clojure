FROM amd64/eclipse-temurin:17-jdk-focal

RUN apt-get update
RUN apt-get install -y bash curl git openssl wget
RUN apt-get clean

WORKDIR /root
ENV MAVEN_VERSION 3.9.2
RUN wget https://downloads.apache.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz
RUN tar -xvzf apache-maven-$MAVEN_VERSION-bin.tar.gz
COPY ./mvn-build /root/bin/mvn-build
COPY ./mvn-release /root/bin/mvn-release
RUN chmod u+x /root/bin/mvn-build
RUN chmod u+x /root/bin/mvn-release
RUN mkdir /root/.m2
RUN chmod 755 /root/.m2
COPY ./settings.xml /root/.m2
RUN git config --global user.email "rentpath-rprel@rentpath.com"
RUN git config --global user.name "rentpath-rprel"
ENV PATH="/root/bin:/root/apache-maven-${MAVEN_VERSION}/bin:${PATH}"

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
WORKDIR /build
