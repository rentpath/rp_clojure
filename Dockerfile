FROM adoptopenjdk/openjdk8:jdk8u275-b01-slim

RUN apt-get update
RUN apt-get install -y bash curl git make jq wget unzip nodejs
RUN apt-get clean

## clojure CLI
RUN curl -O https://download.clojure.org/install/linux-install-1.10.1.536.sh \
&& chmod +x linux-install-1.10.1.536.sh && ./linux-install-1.10.1.536.sh

## youkit profiler
ARG yourkit_version=2020.9
ARG yourkit_patchlevel=416
RUN mkdir /tmp/profiler && cd /tmp/profiler && curl -LJO https://www.yourkit.com/download/YourKit-JavaProfiler-${yourkit_version}-b${yourkit_patchlevel}.zip && unzip YourKit-JavaProfiler-${yourkit_version}-b${yourkit_patchlevel}.zip && mv YourKit-JavaProfiler-${yourkit_version} /usr/local/share/yourkit-profiler
RUN sed -i 's/java\.util\.logging\.ConsoleHandler\.level.*/java.util.logging.ConsoleHandler.level = WARN/g' /usr/local/share/yourkit-profiler/jre64/conf/logging.properties

## gh-status-reporter to report commit statuses
RUN wget -O /bin/gh-status-reporter https://github.com/Christopher-Bui/gh-status-reporter/releases/download/v0.2.0/linux_amd64_gh-status-reporter \
  && chmod +x /bin/gh-status-reporter

## github-release tool
RUN wget -O /root/linux-amd64-github-release.tar.bz2 https://github.com/aktau/github-release/releases/download/v0.7.2/linux-amd64-github-release.tar.bz2 \
  && tar -xvjf /root/linux-amd64-github-release.tar.bz2 --directory /root \
  && mv /root/bin/linux/amd64/github-release /bin/github-release \
  && chmod +x /bin/github-release

## envconsul
RUN wget -O /root/envconsul.tar.gz https://releases.hashicorp.com/envconsul/0.11.0/envconsul_0.11.0_linux_amd64.tgz \
  && tar -xvzf /root/envconsul.tar.gz \
  && mv ./envconsul /usr/local/bin/envconsul \
  && chmod +x /usr/local/bin/envconsul

## yarn
RUN curl -o- -L https://yarnpkg.com/install.sh | bash

RUN git config --global user.email "rentpath-rprel@rentpath.com"
RUN git config --global user.name "rentpath-rprel"

RUN mkdir -p /root/bin
WORKDIR /root
ENV PATH="/root/bin:${PATH}"
RUN cd /root/bin && curl -LJO https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein && chmod u+x /root/bin/lein

RUN lein

RUN cp /opt/java/openjdk/lib/tools.jar /opt/java/openjdk/jre/lib/tools.jar

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
