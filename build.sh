#!/bin/bash

### Copyright 2012-2013 by Garth Johnson as weave.sh
#
#  This script will build the alpha_engine for testing
#  
# 
#  you can override the javac path by setting JAVAC_EXEC
#

## Configure debug
if [ "ALL" == "${DEBUG:-false}" ]; then
  DEBUG_JAR_ARCHIVE="v"
  CURL_SILENT=''
fi

## Default to silent curl
CURL_SILENT=${CURL_SILENT:=-s}

############### Set java compiler location ##################
## If you are using a raspberry pi with the ARM jdk, use the following line
JAVAC_EXEC=${JAVAC_EXEC:-/opt/jdk1.8.0/bin/javac}

## Otherwise, If java is currently in your executable path, we'll find it
if [ ! -x ${JAVAC_EXEC} ]; then
   JAVAC_EXEC=$(which javac)
fi

## Make sure javac is here and executable
if [ ! -x ${JAVAC_EXEC} ]; then
  echo "Unable to locate java compiler at: ${JAVAC_EXEC}"
  exit 1
fi

## Look for the jar tool in the same location as javac
if [ "EMPTY" == "${JAVA_BASE:-EMPTY}" ]; then
    JAVA_BASE=${JAVAC_EXEC%$(basename ${JAVAC_EXEC})}
fi
if [ ! -x ${JAVA_BASE}/jar ]; then
  echo "Unable to locate java archive tool at: ${JAVA_BASE}jar"
fi






############### Install a network plugin ##################
# We need to include at least one grid processor feed to do any actual work.
# The following will download and install the library from PluraProcessing
# This will result in two directories being created (./com and ./META-INFO)
#   containing the modules we need to do attach to plura's networ feed
curl ${CURL_SILENT} http://www.pluraprocessing.com/developer/downloads/plura-affiliate-app-connector.jar |${JAVA_BASE}jar -x${DEBUG_JAR_ARCHIVE}

# Please make sure you have read and understand the network's terms of use, available here:
#   http://pluraprocessing.com/affiliatetou.pdf
echo "You will need to enter 'touch README-PluraProcessing.pdf.accept' to accept Plura's Terms of Use"
curl ${CURL_SILENT} http://pluraprocessing.com/affiliatetou.pdf > README-PluraProcessing.pdf






############### Build test client ##################
# Now we will attempt to compile the provided example code
# " -d ." will cause the compiled class to be installed properly as sh/weave/alpha_engine.class
echo "Compiling, this will take a moment..."
${JAVAC_EXEC} -d . src/alpha_engine.java

