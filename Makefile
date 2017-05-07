DATA_DIR = data
TEMP_IMAGE = ts_temp
TS_VERSION = latest

.PHONY: init

init:
	@ docker rm -f ts_temp > /dev/null 2>&1; true

	@ docker pull amclain/teamspeak:$(TS_VERSION)
	@ echo "Initializing database..."
	@ docker run -d --name $(TEMP_IMAGE) amclain/teamspeak:$(TS_VERSION) > /dev/null
	@ sleep 4
	@ docker stop $(TEMP_IMAGE) > /dev/null

	@ echo "Copying files..."
	@ mkdir -p $(DATA_DIR)
	@ docker cp $(TEMP_IMAGE):/opt/teamspeak3-server_linux_amd64/ts3server.sqlitedb $(DATA_DIR)
	@ docker cp $(TEMP_IMAGE):/opt/teamspeak3-server_linux_amd64/ts3server.sqlitedb-shm $(DATA_DIR)
	@ docker cp $(TEMP_IMAGE):/opt/teamspeak3-server_linux_amd64/ts3server.sqlitedb-wal $(DATA_DIR)
	@ docker cp $(TEMP_IMAGE):/opt/teamspeak3-server_linux_amd64/query_ip_blacklist.txt $(DATA_DIR)
	@ docker cp $(TEMP_IMAGE):/opt/teamspeak3-server_linux_amd64/query_ip_whitelist.txt $(DATA_DIR)
	@ docker cp $(TEMP_IMAGE):/opt/teamspeak3-server_linux_amd64/files $(DATA_DIR)
	@ docker cp $(TEMP_IMAGE):/opt/teamspeak3-server_linux_amd64/logs $(DATA_DIR)

	@ # Print server login info and token.
	@ docker logs $(TEMP_IMAGE) > /dev/null

	@ docker rm -f $(TEMP_IMAGE) > /dev/null

	@ echo "Data files are located in directory: $(DATA_DIR)"
