FROM debian:stable-slim

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install default-jre python3-pip python3-venv -y
RUN mkdir -p /opt/minecraft/bin/downloader
RUN mkdir -p /opt/minecraft/etc/

EXPOSE 25565

ARG MC_VERSION=latest

COPY download_server_jar.py /opt/minecraft/bin/downloader/
COPY requirements.txt /opt/minecraft/bin/downloader/

RUN pip3 install -r /opt/minecraft/bin/downloader/requirements.txt

RUN python3 /opt/minecraft/bin/downloader/download_server_jar.py ${MC_VERSION} /opt/minecraft/bin

COPY start.sh /opt/minecraft/bin/

WORKDIR /opt/minecraft/etc/

ENTRYPOINT ["/bin/bash", "/opt/minecraft/bin/start.sh"]
