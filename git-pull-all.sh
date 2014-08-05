#!/bin/sh -e

SRC=/home/gp/bluejimp/src
MODULES_HOME="$SRC/jitsi-modules"
JVB_HOME="$SRC/jitsi-videobridge"
JITSI_HOME="$SRC/jitsi"
LIBJITSI_HOME="$SRC/libjitsi"

# Pull the modules.
cd "$MODULES_HOME"
for m in * ; do
	if [ -d "$MODULES_HOME/$m" ]; then
		echo "Pulling $m..."
		cd "$MODULES_HOME/$m"
		git pull origin master
	fi
done

echo 'Pulling the video bridge...'
cd "$JVB_HOME"
git pull origin master

echo 'Pulling libjitsi...'
cd "$LIBJITSI_HOME"
git pull origin master

echo 'Pulling jitsi...'
cd "$JITSI_HOME"
git pull origin master
