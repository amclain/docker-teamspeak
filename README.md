# docker-teamspeak

A [Docker](https://www.docker.com/) container for running a [TeamSpeak 3 server](https://www.teamspeak.com/).

## Configuration

The following is an example of a `docker-compose.yml` file for running this image:

```yml
version: "2"
services:
  teamspeak:
    image: amclain/teamspeak
    restart: unless-stopped
    ports:
      - "9987:9987/udp"
      - "10011:10011"
      - "30033:30033"
    volumes:
      - "./data/ts3server.sqlitedb:/opt/teamspeak3-server_linux_amd64/ts3server.sqlitedb"
      - "./data/ts3server.sqlitedb-shm:/opt/teamspeak3-server_linux_amd64/ts3server.sqlitedb-shm"
      - "./data/ts3server.sqlitedb-wal:/opt/teamspeak3-server_linux_amd64/ts3server.sqlitedb-wal"
      - "./data/query_ip_blacklist.txt:/opt/teamspeak3-server_linux_amd64/query_ip_blacklist.txt"
      - "./data/query_ip_whitelist.txt:/opt/teamspeak3-server_linux_amd64/query_ip_whitelist.txt"
      - "./data/files:/opt/teamspeak3-server_linux_amd64/files"
      - "./data/logs:/opt/teamspeak3-server_linux_amd64/logs"
```

The `volumes` section maps the TeamSpeak data files to the host machine so that the container can be easily upgraded without losing data. It also makes it easy to backup the data or move it to another host. If you are migrating from an existing installation, simply map your existing files into the container. If you are creating a new server, see the [`Initialization`](#initialization) section.

## Initialization

If you are creating a new TeamSpeak server, it is recommended to map the data files to the host so that the container can be upgraded without destroying the data. Since the TeamSpeak server generates a unique login, password, and token when it first launches, these files can't be baked into the container image; every admin needs to generate their own. This is what `make init` is for.

To initialize a new set of TeamSpeak data:
1. Copy or git clone the [`Makefile`](Makefile) to the host computer.
2. Run `make init`. This will create a `data` directory, as well as print your unique server login, password, and token. Make sure your `volumes` are pointed to the files in this directory.
3. Start the server.
