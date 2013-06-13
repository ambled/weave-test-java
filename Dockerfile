# Weave Java test client builder for Docker.io
#
# VERSION	0.1.0

FROM	base
MAINTAINER	Garth Johnson "docker@weave.sh"

# Update repositories so we can grab java
RUN	echo "deb http://archive.ubuntu.com precise main universe" > /etc/apt/srouces.list
RUN	apt-get -y update

# install git client, curl and openjdk6
RUN	apt-get -y install git curl openjdk-6-jdk

# override defaults for engine
ENV     PLURA_SESSION docker-world
ENV     DOCKER_WEAVE_MAXMEM 256m
ENV     DOCKER_WEAVE_MINMEM 128m

### pull down code from github
#RUN	mkdir -p /opt
#RUN	git clone https://github.com/ambled/weave-test-java /opt/weave-test-java
### or, clone locally and copy directly, accept TOS agreements in the
###   local repository below to have it merged with your Docker automatically
ADD	. /opt/weave-test-java

# Build client
RUN	cd /opt/weave-test-java && ./build.sh

# What we run by default
CMD    /opt/weave-test-java/start.sh

