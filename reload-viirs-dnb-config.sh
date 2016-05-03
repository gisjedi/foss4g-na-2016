#!/bin/bash

POST_CONTAINER=`docker-compose ps -q postgis`
GEOSERVER_CONTAINER=`docker-compose ps -q geoserver`
docker exec ${POST_CONTAINER} su - postgres -c "bash /tmp/postgis/initial-viirs-dnb.sh"

docker exec ${GEOSERVER_CONTAINER} apt-get install curl wget -y
docker exec ${GEOSERVER_CONTAINER} bash /tmp/geoserver/reload-viirs-dnb.sh
