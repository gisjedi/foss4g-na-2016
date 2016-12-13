#!/bin/bash

# Ensure we are in a location that is writable
cd /tmp

# Identify year for pulling data
YEAR=$(date +'%Y')
SOURCEPAGE=modisfire_${YEAR}_conus.htm
OPTS=--no-check-certificate

# Identify shapefile with current days data
wget $OPTS https://fsapps.nwcg.gov/afm/data/fireptdata/$SOURCEPAGE
SHAPEFILEZIP=`cat $SOURCEPAGE |grep shapefile -m 1| cut -d "\"" -f 2`
rm $SOURCEPAGE
echo $SHAPEFILEZIP

# Grab file name only and unzip dataset
wget $OPTS $SHAPEFILEZIP
SHAPEFILEZIP=$(basename $SHAPEFILEZIP)
unzip $SHAPEFILEZIP
rm $SHAPEFILEZIP

# Strip extension off name and convert shapefile to a SQL script
echo stripping file name to prefix
SHAPEFILEPRE=${SHAPEFILEZIP/_shapefile/}
SHAPEFILEPRE=`echo $SHAPEFILEPRE | cut -d "." -f 1`
shp2pgsql -I -D -d -s 4326 $SHAPEFILEPRE.shp public.modis > /tmp/tempdata.sql

# Start  database so that we can execute the data intialization tasks
psql -c "CREATE DATABASE modis;"
psql -c "CREATE EXTENSION postgis;" modis
psql -f /tmp/tempdata.sql modis

# Cleanup scratch files
rm $SHAPEFILEPRE.*
rm /tmp/tempdata.sql
