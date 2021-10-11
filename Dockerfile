FROM adoptopenjdk/openjdk8:jdk8u275-b01-slim

RUN apt-get update
RUN apt-get install -y bash curl git make jq wget unzip nodejs
RUN apt-get clean

## clojure CLI
RUN curl -O https://download.clojure.org/install/linux-install-1.10.3.986.sh \
&& chmod +x linux-install-1.10.3.986.sh && ./linux-install-1.10.3.986.sh

RUN git config --global user.email "rentpath-rprel@rentpath.com"
RUN git config --global user.name "rentpath-rprel"

RUN mkdir -p /root/bin
RUN mkdir /build

## Badigeon
WORKDIR /root
ENV PATH="/root/bin:${PATH}"
RUN mkdir /root/.m2
RUN chmod 755 /root/.m2
COPY ./settings.xml /root/.m2
COPY ./badigeon-build /root/bin/badigeon-build
COPY ./badigeon-release /root/bin/badigeon-release
RUN chmod u+x /root/bin/badigeon-build
RUN chmod u+x /root/bin/badigeon-release

RUN cp /opt/java/openjdk/lib/tools.jar /opt/java/openjdk/jre/lib/tools.jar

RUN echo "options ndots:3" >> /etc/resolv.conf

# The below env vars are expected to be supplied by the builder
# ENV NEXUS_USERNAME
# ENV NEXUS_PASSWORD
# ENV IS_MASTER

WORKDIR /build
