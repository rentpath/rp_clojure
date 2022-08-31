FROM eclipse-temurin:8-jre-focal

RUN apt-get update
RUN apt-get install -y bash curl git make jq wget unzip
RUN apt-get clean

## clojure CLI
RUN curl -O https://download.clojure.org/install/linux-install-1.11.1.1155.sh \
&& chmod +x linux-install-1.11.1.1155.sh && ./linux-install-1.11.1.1155.sh

RUN git config --global user.email "rentpath-rprel@rentpath.com"
RUN git config --global user.name "rentpath-rprel"

RUN mkdir -p /root/bin
RUN mkdir /build

RUN git config --global --add safe.directory /build

## leiningen
WORKDIR /root
ENV PATH="/root/bin:${PATH}"
COPY ./clj-build /root/bin/clj-build
COPY ./clj-release /root/bin/clj-release
RUN chmod u+x /root/bin/clj-build
RUN chmod u+x /root/bin/clj-release

RUN echo "options ndots:3" >> /etc/resolv.conf

# The below env vars are expected to be supplied by the builder
# ENV NEXUS_USERNAME
# ENV NEXUS_PASSWORD
# ENV IS_MASTER

WORKDIR /build
