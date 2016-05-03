#!/bin/bash

# Pull down VIIRS tiffs for mosaic
VIIRS_DIR='/srv/geoserver/mosaics/viirs-dnb'
mkdir -p ${VIIRS_DIR}/{data,config}
cd ${VIIRS_DIR}/data

FTP_URL='ftp://ftp.ssec.wisc.edu/pub/eosdb/npp/viirs/'
ACCEPT_PATTERN='npp_viirs_adaptive_dnb*.tif'
DIR_ACCEPT_PATTERN='pub/eosdb/npp/viirs/*,pub/eosdb/npp/viirs/*/geotiff'
# -nc No clobber, i.e. don't retrieve existing files.
# -nd No directories. Flatten the tree and place all files in current directory.
# -np No parent. Don't ascend the directory tree.
# --follow-ftp Traverse FTP links
# -A Accept pattern to use for files.
# -I Accept pattern to only include directories containing needed files.
# -r Recursively search the directory tree.

wget -nc -nd -np --follow-ftp -A "${ACCEPT_PATTERN}" -I "${DIR_ACCEPT_PATTERN}" -r "${FTP_URL}"

# Create inner tiles and overviews to ensure snappy rendering performance
for FILE in `ls *.tif`; do
    echo ${FILE}
    gdal_translate -co "TILED=YES" -co "BLOCKXSIZE=512" -co "BLOCKYSIZE=512" ${FILE} tiled_${FILE}
    gdaladdo -r average tiled_${FILE} 2 4 8 16 32
    mv tiled_${FILE} ${FILE}
done

cp /tmp/geoserver/viirs-dnb/* ${VIIRS_DIR}/data

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
curl -v -u admin:geoserver -XDELETE http://localhost:8080/geoserver/rest/workspaces/mosaic?recurse=true
curl -v -u admin:geoserver -XPOST -H "Content-type: text/xml" -d "<workspace><name>mosaic</name></workspace>" http://localhost:8080/geoserver/rest/workspaces
curl -v -u admin:geoserver -XPOST -T ${DIR}/viirs-store.xml -H "Content-type: text/xml" http://localhost:8080/geoserver/rest/workspaces/mosaic/coveragestores
curl -v -u admin:geoserver -XPOST -T ${DIR}/viirs-dnb.xml -H "Content-type: text/xml" http://localhost:8080/geoserver/rest/workspaces/mosaic/coveragestores/viirs-dnb/coverages
