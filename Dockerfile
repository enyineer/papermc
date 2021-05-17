FROM debian:stable AS dl

WORKDIR /download

ARG MC_VERSION
ARG PAPER_VERSION

RUN apt update && \
    apt upgrade -y && \
    apt install curl -y && \
    curl https://papermc.io/api/v2/projects/paper/versions/${MC_VERSION}/builds/${PAPER_VERSION}/downloads/paper-${MC_VERSION}-${PAPER_VERSION}.jar --output paper.jar

FROM openjdk:16-slim-buster

ARG MC_VERSION
ARG PAPER_VERSION

ENV ACCEPT_EULA=n
ENV OVERWRITE_SETTINGS=n
ENV BASE_CONFIG_DIR="/etc/papermc"
ENV JAVA_OPTS="-XX:+UnlockExperimentalVMOptions -XX:+UseContainerSupport -XX:MaxRAMPercentage=70"

WORKDIR /paper

COPY --from=dl /download/paper.jar paper.jar
COPY entrypoint.sh .

CMD ["/bin/bash", "-c", "./entrypoint.sh"]
