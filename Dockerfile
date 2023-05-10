FROM eclipse-temurin:8-jre-focal

# Update packages with known vulnerabilities
RUN apt-get update
RUN apt-get install -y --only-upgrade openssl zlib1g