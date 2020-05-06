FROM openjdk:8u151-jdk

ARG yourkit_version=2019.8
ARG yourkit_patchlevel=138

RUN apt-get update
RUN apt-get install -y git make python g++ lsb-release iptables apt-transport-https ca-certificates
RUN curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
RUN echo "deb https://deb.nodesource.com/node_8.x $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/nodesource.list
RUN echo "deb-src https://deb.nodesource.com/node_8.x $(lsb_release -sc) main" | tee -a /etc/apt/sources.list.d/nodesource.list
RUN apt-get update
RUN apt-get install -y nodejs jq mongodb-clients

# npm is used for dredd
RUN npm install

## gh-status-reporter to report commit statuses
RUN wget -O /bin/gh-status-reporter https://github.com/Christopher-Bui/gh-status-reporter/releases/download/v0.2.0/linux_amd64_gh-status-reporter \
  # This is needed since gh-status-reporter was built without musl
  && chmod +x /bin/gh-status-reporter

## github-release tool
RUN wget -O /root/linux-amd64-github-release.tar.bz2 https://github.com/aktau/github-release/releases/download/v0.7.2/linux-amd64-github-release.tar.bz2 \
  && tar -xvjf /root/linux-amd64-github-release.tar.bz2 --directory /root \
  && mv /root/bin/linux/amd64/github-release /bin/github-release \
  && chmod +x /bin/github-release

RUN git config --global user.email "rentpath-rprel@rentpath.com"
RUN git config --global user.name "rentpath-rprel"

RUN mkdir -p /root/bin
WORKDIR /root
ENV PATH="/root/bin:${PATH}"
RUN cd /root/bin && curl -LJO https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein && chmod u+x /root/bin/lein
RUN mkdir /tmp/profiler && cd /tmp/profiler && curl -LJO https://www.yourkit.com/download/YourKit-JavaProfiler-${yourkit_version}-b${yourkit_patchlevel}.zip && unzip YourKit-JavaProfiler-${yourkit_version}-b${yourkit_patchlevel}.zip && mv YourKit-JavaProfiler-${yourkit_version} /usr/local/share/yourkit-profiler

RUN lein

ONBUILD COPY . /root

ONBUILD ARG BUILD_ORG_REPO
ONBUILD ARG BUILD_AUTH
ONBUILD ARG BUILD_BRANCH
ONBUILD ARG BUILD_SHA
ONBUILD ARG BUILD_NUMBER
ONBUILD ARG BUILD_TARGET_URL

ONBUILD ENV BUILD_NUMBER=$BUILD_NUMBER \
  BUILD_BRANCH=$BUILD_BRANCH \
  BUILD_SHA=$BUILD_SHA \
  BUILD_ORG_REPO=$BUILD_ORG_REPO \
  BUILD_TARGET_URL=$BUILD_TARGET_URL \
  BUILD_AUTH=$BUILD_AUTH

ONBUILD RUN echo "options ndots:3" >> /etc/resolv.conf \
  && make -f makefile.docker build \
  && make -f makefile.docker release
