FROM ubuntu:18.04

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install curl default-jre python3-pip python3-venv -y
RUN mkdir -p /opt/minecraft/bin/downloader
RUN mkdir -p /opt/minecraft/etc/

EXPOSE 25565

RUN python3 -m venv /opt/minecraft/bin/downloader/venv
RUN /bin/bash /opt/minecraft/bin/downloader/venv/bin/activate && pip3 install requests

ARG MC_VERSION=1.14.4

COPY download_server_jar.py /opt/minecraft/bin/downloader/
RUN /bin/bash /opt/minecraft/bin/downloader/venv/bin/activate && \
    python3 /opt/minecraft/bin/downloader/download_server_jar.py ${MC_VERSION} /opt/minecraft/bin

COPY start.sh /opt/minecraft/bin/

WORKDIR /opt/minecraft/etc/

ENTRYPOINT ["/bin/bash", "/opt/minecraft/bin/start.sh"]
