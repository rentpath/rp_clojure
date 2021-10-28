FROM adoptopenjdk:8u292-b10-jre-openj9-0.26.0-focal

RUN apt-get update
RUN apt-get install -y bash curl git make jq wget unzip
RUN apt-get clean

## clojure CLI
RUN curl -O https://download.clojure.org/install/linux-install-1.10.3.998.sh \
&& chmod +x linux-install-1.10.3.998.sh && ./linux-install-1.10.3.998.sh

RUN git config --global user.email "rentpath-rprel@rentpath.com"
RUN git config --global user.name "rentpath-rprel"

RUN mkdir -p /root/bin
RUN mkdir /build

## leiningen
WORKDIR /root
ENV PATH="/root/bin:${PATH}"
RUN cd /root/bin && curl -LJO https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein && chmod u+x /root/bin/lein
COPY ./lein-build /root/bin/lein-build
COPY ./lein-release /root/bin/lein-release
RUN chmod u+x /root/bin/lein-build
RUN chmod u+x /root/bin/lein-release

RUN echo "options ndots:3" >> /etc/resolv.conf

RUN lein

# The below env vars are expected to be supplied by the builder
# ENV NEXUS_USERNAME
# ENV NEXUS_PASSWORD
# ENV IS_MASTER

WORKDIR /build
