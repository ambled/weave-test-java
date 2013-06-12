#!/bin/bash

### Copyright 2012-2013 by Garth Johnson as weave.sh
#
#  This script will start the alpha_engine for testing
#  
# 

cd "$( dirname "${BASH_SOURCE[0]}" )"

############### Set registered user ##################
#If you have registered, you can change the workerId
REGISTERED_WORKER_ID=${PLURA_SESSION?hello-world}

############### Set optional logfile location ##################
## These setup a logfile if your interested in analyzing the output later
##   The filename to use will be based on the hour that you start the client
##   eg: <LOG_PATH>/130334-01.log
LOG_PATH="./log/"
LOG_DATE=$(date +'%y%m%d-%H')

## uncomment the following line to dump the java logs into a file for review
# WEAVE_LOG="${LOG_PATH}${LOG_DATE}.log"

############### Set java location ##################
## Use this location for the raspberry pi and the preview ARM jdk
JAVA_EXEC=/opt/jdk1.8.0/bin/java

############### Set java heap memory ##################
## If you have a 256MB version B1 raspberry pi, use the following settings
##   You may have to change your gpu_mem setting in /boot/config.txt (I have it set to 16)
MAX_MEMORY=${DOCKER_WEAVE_MAXMEM:-100m}
MIN_MEMORY=${DOCKER_WEAVE_MINMEM:-100m}

## If you have a 512MB version raspberry pi, use the following settings
#MAX_MEMORY=256m
#MIN_MEMORY=256m



############### Load the values from the config file ###############
if [ -f /etc/weave.conf ]; then
  . /etc/weave.conf
fi

############### Check User Agreements ###############
## Make sure user has acknowledged partner/network agreements
for file in README-*.pdf
do
  if [ ! -e "${file}.accept" ]; then
    echo "Please accept third party agreements by typing the following: "
    echo -e "touch ${file}.accept\n"
    UNACCEPTED_AGREEMENTS="FAIL"
  fi
done

## Bail if there are agreements to accept
if [ "NONE" != "${UNACCEPTED_AGREEMENTS:-NONE}" ];then
  read -p "This application will share your computer, Do you understand? [y/n] " -n 1
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "Aborting...\n"
    exit 1
  fi
fi

## If java is currently in your executable path, this will find it
if [ ! -x ${JAVA_EXEC} ]; then
  JAVA_EXEC=$(which java)
fi

## Make sure java is here and executable
if [ ! -x ${JAVA_EXEC} ]; then
  echo "Unable to locate java virtual machine at: ${JAVA_EXEC}"
  echo "Please go here to download and install the Java SDK for RaspberryPi"
  echo "If you're using a different platform, install Java SDK >= v1.6"
  echo "  http://jdk8.java.net/fxarmpreview/"
  exit 1
fi

############### Now startup the client, enabling logging if requested ##################
## If WEAVE_LOG is set and has a path that exists
if [ -n "${WEAVE_LOG}" ]; then
  # Make sure we can access the log file
  touch ${WEAVE_LOG}
  if [ -f ${WEAVE_LOG} ];then
    ${JAVA_EXEC} -Xmx${MAX_MEMORY} -Xms${MIN_MEMORY} -XX:+CMSClassUnloadingEnabled sh.weave.alpha_engine ${REGISTERED_WORKER_ID} >> ${WEAVE_LOG}
  else
    echo -e "Unable to create logfile ${WEAVE_LOG}\n"
  fi
else
  ${JAVA_EXEC} -Xmx${MAX_MEMORY} -Xms${MIN_MEMORY} -XX:+CMSClassUnloadingEnabled sh.weave.alpha_engine ${REGISTERED_WORKER_ID} 
fi
