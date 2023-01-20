FROM amd64/eclipse-temurin:17-jre-focal

# Update packages with known vulnerabilities
RUN apt-get update
RUN apt-get install -y --only-upgrade openssl zlib1g