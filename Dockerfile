FROM adoptopenjdk:8u292-b10-jdk-openj9-0.26.0-focal

# Security has identified a vulnerability in the previous version of the zlib1g library, necessitating an update thereto.
RUN apt-get update && apt-get install --only-upgrade zlib1g
