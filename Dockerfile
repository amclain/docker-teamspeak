FROM ubuntu:trusty
MAINTAINER Alex McLain <alex@alexmclain.com>

# Install system packages.
RUN apt-get -qq update && \
    apt-get -y dist-upgrade && \
    apt-get -y install wget

# Install TeamSpeak server.
ENV TS_VERSION=3.0.13.3

RUN wget http://dl.4players.de/ts/releases/${TS_VERSION}/teamspeak3-server_linux_amd64-${TS_VERSION}.tar.bz2
RUN tar -xjf teamspeak3-server_linux_amd64-${TS_VERSION}.tar.bz2
RUN rm teamspeak3-server_linux_amd64-${TS_VERSION}.tar.bz2
RUN mv teamspeak3-server_linux_amd64 /opt

EXPOSE 9987/udp 10011 30033

ENTRYPOINT ["/opt/teamspeak3-server_linux_amd64/ts3server_minimal_runscript.sh"]
