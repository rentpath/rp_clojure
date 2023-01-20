FROM eclipse-temurin:17-jre-focal

# Security has identified a vulnerability in the previous version of the zlib1g library, necessitating an update thereto.
RUN apt-get update && apt-get install --only-upgrade zlib1g