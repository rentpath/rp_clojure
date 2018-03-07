FROM openjdk:8u151-jdk-alpine

RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community bash curl git

RUN git config --global user.email "rentpath-rprel@rentpath.com"
RUN git config --global user.name "rentpath-rprel"

RUN mkdir -p /root/bin
WORKDIR /root
ENV PATH="/root/bin:${PATH}"
RUN cd /root/bin && curl -LJO https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein && chmod u+x /root/bin/lein

RUN lein

ONBUILD COPY . /root

ONBUILD ARG BUILD_NUMBER
ONBUILD ENV BUILD_NUMBER=$BUILD_NUMBER

ONBUILD RUN script/bootstrap
ONBUILD RUN script/test
ONBUILD RUN script/build
