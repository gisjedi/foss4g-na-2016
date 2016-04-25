#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
curl -v -u admin:geoserver -XDELETE http://localhost:8080/geoserver/rest/workspaces/feature?recurse=true
curl -v -u admin:geoserver -XPOST -H "Content-type: text/xml" -d "<workspace><name>feature</name></workspace>" http://localhost:8080/geoserver/rest/workspaces
curl -v -u admin:geoserver -XPOST -T ${DIR}/modis-store.xml -H "Content-type: text/xml" http://localhost:8080/geoserver/rest/workspaces/feature/datastores
curl -v -u admin:geoserver -XPOST -T ${DIR}/modis.xml -H "Content-type: text/xml" http://localhost:8080/geoserver/rest/workspaces/feature/datastores/modis/featuretypes
