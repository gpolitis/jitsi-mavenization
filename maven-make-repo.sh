#!/bin/sh -e

MAVEN_REPO="$(mvn help:evaluate -Dexpression=settings.localRepository | grep -v '[INFO]')"
GROUP_ID=org.jitsi

# Adjust the following 3 variables to suit your environment.
JITSI_HOME="$HOME/BlueJimp/src/org.jitsi.sipcomm"
LIBJITSI_HOME="$HOME/BlueJimp/src/org.jitsi.libjitsi"
JVB_HOME="$HOME/BlueJimp/src/org.jitsi.videobridge"

install_lib() {
	local FILE="$1"
	local ARTIFACT_ID="$2"
	local VERSION="$3"

	if [ -z "$VERSION" ] ; then
		VERSION='1.0-SNAPSHOT'
	fi
	local INSTALLED_FILE="$MAVEN_REPO/${GROUP_ID/\.//}/$ARTIFACT_ID/$VERSION/$ARTIFACT_ID-$VERSION.jar"
	if ! cmp "$FILE" "$INSTALLED_FILE" >/dev/null 2>&1; then
		mvn install::install-file \
			-DcreateChecksum=true \
			-Dpackaging=jar \
			-Dfile="$FILE" \
			-DgroupId="$GROUP_ID" \
			-DartifactId="$ARTIFACT_ID" \
			-Dversion="$VERSION" >/dev/null
		
		echo "Installed $INSTALLED_FILE"
	fi
}

# install jitsi libs
install_lib $JITSI_HOME/lib/installer-exclude/ymsg_network_v0_67.jar ymsg-network 0.6.7
install_lib $JITSI_HOME/lib/installer-exclude/profiler4j-1.0-beta3-SC.jar profiler4j 1.0-beta3
install_lib $JITSI_HOME/lib/installer-exclude/joscar-client.jar joscar-client 
install_lib $JITSI_HOME/lib/installer-exclude/joscar-common.jar joscar-common
install_lib $JITSI_HOME/lib/installer-exclude/joscar-protocol.jar joscar-protocol
install_lib $JITSI_HOME/lib/installer-exclude/jmork-1.0.5-SNAPSHOT.jar jmork 1.0.5-SNAPSHOT
install_lib $JITSI_HOME/lib/installer-exclude/smack.jar smack
install_lib $JITSI_HOME/lib/installer-exclude/smackx.jar smackx
install_lib $JITSI_HOME/lib/installer-exclude/smackx-debug.jar smackx-debug
install_lib $JITSI_HOME/lib/installer-exclude/laf-widget.jar laf-widget 4.0
install_lib $JITSI_HOME/lib/installer-exclude/jnsapi.jar jnsapi 
install_lib $JITSI_HOME/lib/installer-exclude/jmyspell-core.jar jmyspell-core 1.0.0-beta-2
install_lib $JITSI_HOME/lib/installer-exclude/jain-sip-ri.jar jain-sip-ri 1.2.159
install_lib $JITSI_HOME/lib/installer-exclude/jain-sdp.jar jain-sdp 1.0.159
install_lib $JITSI_HOME/lib/installer-exclude/jain-sip-api.jar jain-sip-api 1.2
install_lib $JITSI_HOME/lib/installer-exclude/dict4j.jar dict4j 
install_lib $JITSI_HOME/lib/installer-exclude/dhcp4java-1.00.jar dhcp4java 1.00
install_lib $JITSI_HOME/lib/installer-exclude/dnsjava.jar dnsjava 2.1.6
install_lib $JITSI_HOME/lib/installer-exclude/swing-worker-1.2.jar swing-worker 1.2
install_lib $JITSI_HOME/lib/installer-exclude/jmdns.jar jmdns
install_lib $JITSI_HOME/lib/installer-exclude/gdata-core-1.0.jar gdata-core 1.0
install_lib $JITSI_HOME/lib/installer-exclude/gdata-client-1.0.jar gdata-client 1.0
install_lib $JITSI_HOME/lib/installer-exclude/gdata-client-meta-1.0.jar gdata-client-meta 1.0
install_lib $JITSI_HOME/lib/installer-exclude/gdata-contacts-3.0.jar gdata-contacts 3.0
install_lib $JITSI_HOME/lib/installer-exclude/gdata-contacts-meta-3.0.jar gdata-contacts-meta 3.0
install_lib $JITSI_HOME/lib/installer-exclude/libdbus-java-2.7.jar libdbus-java 2.7
install_lib $JITSI_HOME/lib/installer-exclude/jdic_misc.jar jdic-misc
install_lib $JITSI_HOME/lib/installer-exclude/jna.jar jna 3.2.7
install_lib $JITSI_HOME/lib/installer-exclude/jna-platform.jar jna-platform 3.2.7

# install mac specific jitsi libs
install_lib $JITSI_HOME/lib/installer-exclude/os-specific/mac/growl4j.jar growl4j 
install_lib $JITSI_HOME/lib/installer-exclude/os-specific/mac/OrangeExtensions.jar AppleJavaExtensions

# install libjitsi libs
install_lib $LIBJITSI_HOME/lib/jspeex.jar jspeex 0.9.7
install_lib $LIBJITSI_HOME/lib/zrtp4j-light.jar zrtp4j-light 
install_lib $LIBJITSI_HOME/lib/bccontrib-1.0-SNAPSHOT.jar bccontrib 

# install jitsi videobridge libs
install_lib $JVB_HOME/lib/whack.jar whack
install_lib $JVB_HOME/lib/xpp3.jar xpp3
install_lib $JVB_HOME/lib/jitsi-android-osgi.jar osgi-android
install_lib $JVB_HOME/lib/sigar.jar sigar 1.6.4

