#!/bin/bash

# Pull down VIIRS tiffs for mosaic
VIIRS_DIR='/srv/geoserver/mosaics/viirs-dnb'

rm -fr ${VIIRS_DIR}/config
mkdir -p ${VIIRS_DIR}/config
cp /tmp/geoserver/viirs-dnb/* ${VIIRS_DIR}/config

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
curl -v -u admin:geoserver -XDELETE http://localhost:8080/geoserver/rest/workspaces/mosaic?recurse=true
curl -v -u admin:geoserver -XPOST -H "Content-type: text/xml" -d "<workspace><name>mosaic</name></workspace>" http://localhost:8080/geoserver/rest/workspaces
curl -v -u admin:geoserver -XPOST -T ${DIR}/viirs-store.xml -H "Content-type: text/xml" http://localhost:8080/geoserver/rest/workspaces/mosaic/coveragestores
curl -v -u admin:geoserver -XPOST -T ${DIR}/viirs-dnb.xml -H "Content-type: text/xml" http://localhost:8080/geoserver/rest/workspaces/mosaic/coveragestores/viirs-dnb/coverages
