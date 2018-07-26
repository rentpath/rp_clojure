FROM openjdk:10.0.1-jdk-slim

RUN apt-get update
RUN apt-get install -y bash curl git make jq nodejs npm python g++ wget
RUN apt-get clean

## dredd needed for listing svc
RUN npm install -g dredd

## gh-status-reporter to report commit statuses
RUN wget -O /bin/gh-status-reporter https://github.com/Christopher-Bui/gh-status-reporter/releases/download/v0.2.0/linux_amd64_gh-status-reporter \
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

RUN lein
