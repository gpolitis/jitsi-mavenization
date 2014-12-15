#!/bin/sh -e

script_path=$( cd $(dirname $0) ; pwd -P )
sc_home=$HOME/BlueJimp/src/org.jitsi.sip-communicator/

for artifact in $script_path/artifacts/net.java.sip.communicator.*; do 
	"$script_path/jitsi-generate-artifact.sh" "$sc_home" `basename $artifact`; 
done
