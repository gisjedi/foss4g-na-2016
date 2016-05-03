# FOSS4G North America 2016 - Image Mosaics & Automation 
Scripts to construct docker containers and populate with up to date MODIS and VIIRS DNB data. Compose support for a full
stand up of OGC Preview and GeoServer fronting PostGIS.

Slides can be found at http://gisjedi.github.io/foss4g-na-2016

## Prerequisites
Docker 1.10+ and Docker Compose 1.6+ to ensure a consistent experience on all platforms. Instructions for installation
on your platform of choice can be found at https://docs.docker.com/engine/installation/ and
https://docs.docker.com/compose/install/


## Build
Construct the GeoServer and Apache containers by running build:

```docker-compose build```

## Daemonize
Create daemonized instance of the containers:

```docker-compose up -d```

## Initialize
Populate PostGIS with MODIS data and GeoServer with layer exposing table:

```bash initial-modis.sh```

Populate PostGIS with VIIRS data footprints and GeoServer with layer exposing GeoTIFFs:

```bash initial-viirs-dnb.sh```

## Prosper
Access your newly constructed containers on either http://localhost (Linux only) or identify the IP of your virtualized
docker host (Mac / Windows):

```docker-machine ip default```

Access OGC preview at either http://localhost/ or http://yourip/

## Caveats

Docker was originally designed for Linux so YMMV on Mac / Windows environments. As of Docker Toolbox 1.10+ Windows and 
Mac provide a fairly consistent experience, but be aware of the key limitation of Docker Machine: above commands will 
only work in their entirety when project is cloned into the User's home directory or a subdirectory.  Reference 
https://github.com/docker/compose/issues/2548. 
