#!/bin/bash

### Copyright 2012-2013 by Garth Johnson as weave.sh
#
#  This script will prepare the alpha_engine for docker build
#  

## Configure debug
if [ "ALL" == "${DEBUG:-false}" ]; then
  DEBUG_JAR_ARCHIVE="v"
  CURL_SILENT=''
fi

## Default to silent curl
CURL_SILENT=${CURL_SILENT:=-s}

############### Install a network plugin ##################
# We need to include at least one grid processor feed to do any actual work.
# The following will download and install the library from PluraProcessing
# This will result in two directories being created (./com and ./META-INFO)
#   containing the modules we need to do attach to plura's networ feed
if [ ! -f README-PluraProcessing.pdf ]; then
    curl ${CURL_SILENT} http://www.pluraprocessing.com/developer/downloads/plura-affiliate-app-connector.jar |${JAVA_BASE}jar -x${DEBUG_JAR_ARCHIVE}

    echo "Please make sure you have read and understand the network's terms of use, available here:"
    echo -e "http://pluraprocessing.com/affiliatetou.pdf\n"
    echo "You will need to enter 'touch README-PluraProcessing.pdf.accept' to accept Plura's Terms of Use"
    curl ${CURL_SILENT} http://pluraprocessing.com/affiliatetou.pdf > README-PluraProcessing.pdf
fi

