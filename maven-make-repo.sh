#!/bin/sh -e

REPO=$HOME/.m2/repository

JITSI_HOME=$HOME/bluejimp/src

JITSI_BUNDLES=$JITSI_HOME/jitsi/sc-bundles
JITSI_LIBS_INSTALLER_EXCLUDE=$JITSI_HOME/jitsi/lib/installer-exclude
JITSI_LIBS_MAC=$JITSI_HOME/jitsi/lib/os-specific/mac
LIBJITSI_LIBS=$JITSI_HOME/libjitsi/lib
JVB_LIBS=$JITSI_HOME/jitsi-videobridge/lib

FORCE_LIB_UPDATE=0
FORCE_BUNDLE_UPDATE=1

build_jitsi() {
	local curpath="$(pwd)"
	cd "$JITSI_HOME/jitsi"
	ant rebuild
	cd "$curpath"
}

install_lib() {
	local file=$1
	local artifactId=$2
	local version=$3

	# TODO check that the file exists.

	if [ -z "$version" ] ; then
		version='1.0-SNAPSHOT'
	fi

	if [ -f $REPO/local/jitsi/libs/$artifactId/$version/$artifactId-$version.jar -a "$FORCE_LIB_UPDATE" != "1" ]
	then
		return
	fi

	mvn install::install-file \
		-DcreateChecksum=true \
		-Dpackaging=jar \
		-Dfile="$file" \
		-DgroupId=local.jitsi.libs \
		-DartifactId="$artifactId" \
		-Dversion="$version"
}

install_bundle() {
	local file=$JITSI_BUNDLES/$1.jar
	local artifactId=$1
	local version=$3

	# TODO check that the file exists.

	if [ -z "$version" ] ; then
		version='1.0-SNAPSHOT'
	fi

	if [ -f $REPO/local/jitsi/bundles/$artifactId/$version/$artifactId-$version.jar -a "$FORCE_BUNDLE_UPDATE" != "1" ]
	then
		return
	fi

	mvn install::install-file \
		-DcreateChecksum=true \
		-Dpackaging=jar \
		-Dfile="$file" \
		-DgroupId=local.jitsi.bundles \
		-DartifactId="$artifactId" \
		-Dversion="$version"
}


# jitsi libs
install_lib $JITSI_LIBS_INSTALLER_EXCLUDE/ymsg_network_v0_67.jar ymsg-network 0.6.7
install_lib $JITSI_LIBS_INSTALLER_EXCLUDE/profiler4j-1.0-beta3-SC.jar profiler4j 1.0-beta3
install_lib $JITSI_LIBS_INSTALLER_EXCLUDE/joscar-client.jar joscar-client 
install_lib $JITSI_LIBS_INSTALLER_EXCLUDE/joscar-common.jar joscar-common
install_lib $JITSI_LIBS_INSTALLER_EXCLUDE/joscar-protocol.jar joscar-protocol
install_lib $JITSI_LIBS_INSTALLER_EXCLUDE/jmork-1.0.5-SNAPSHOT.jar jmork 1.0.5-SNAPSHOT
install_lib $JITSI_LIBS_INSTALLER_EXCLUDE/smack.jar smack
install_lib $JITSI_LIBS_INSTALLER_EXCLUDE/smackx.jar smackx
install_lib $JITSI_LIBS_INSTALLER_EXCLUDE/smackx-debug.jar smackx-debug
install_lib $JITSI_LIBS_INSTALLER_EXCLUDE/laf-widget.jar laf-widget 4.0
install_lib $JITSI_LIBS_INSTALLER_EXCLUDE/jnsapi.jar jnsapi 
install_lib $JITSI_LIBS_INSTALLER_EXCLUDE/jmyspell-core.jar jmyspell-core 1.0.0-beta-2
install_lib $JITSI_LIBS_INSTALLER_EXCLUDE/jain-sip-ri.jar jain-sip-ri 1.2.159
install_lib $JITSI_LIBS_INSTALLER_EXCLUDE/jain-sdp.jar jain-sdp 1.0.159
install_lib $JITSI_LIBS_INSTALLER_EXCLUDE/jain-sip-api.jar jain-sip-api 1.2
install_lib $JITSI_LIBS_INSTALLER_EXCLUDE/dict4j.jar dict4j 
install_lib $JITSI_LIBS_INSTALLER_EXCLUDE/dhcp4java-1.00.jar dhcp4java 1.00
install_lib $JITSI_LIBS_INSTALLER_EXCLUDE/dnsjava.jar dnsjava 2.1.6
install_lib $JITSI_LIBS_INSTALLER_EXCLUDE/swing-worker-1.2.jar swing-worker 1.2
install_lib $JITSI_LIBS_INSTALLER_EXCLUDE/jmdns.jar jmdns
install_lib $JITSI_LIBS_INSTALLER_EXCLUDE/gdata-core-1.0.jar gdata-core 1.0
install_lib $JITSI_LIBS_INSTALLER_EXCLUDE/gdata-client-1.0.jar gdata-client 1.0
install_lib $JITSI_LIBS_INSTALLER_EXCLUDE/gdata-client-meta-1.0.jar gdata-client-meta 1.0
install_lib $JITSI_LIBS_INSTALLER_EXCLUDE/gdata-contacts-3.0.jar gdata-contacts 3.0
install_lib $JITSI_LIBS_INSTALLER_EXCLUDE/gdata-contacts-meta-3.0.jar gdata-contacts-meta 3.0
install_lib $JITSI_LIBS_INSTALLER_EXCLUDE/libdbus-java-2.7.jar libdbus-java 2.7
install_lib $JITSI_LIBS_INSTALLER_EXCLUDE/jdic_misc.jar jdic-misc
install_lib $JITSI_LIBS_INSTALLER_EXCLUDE/jna.jar jna 3.2.7
install_lib $JITSI_LIBS_INSTALLER_EXCLUDE/jna-platform.jar jna-platform 3.2.7

# libjitsi
install_lib $LIBJITSI_LIBS/jspeex.jar jspeex 0.9.7
install_lib $LIBJITSI_LIBS/zrtp4j-light.jar zrtp4j-light 
install_lib $LIBJITSI_LIBS/bccontrib-1.0-SNAPSHOT.jar bccontrib 

# jitsi mac libs
install_lib $JITSI_LIBS_MAC/growl4j.jar growl4j 
install_lib $JITSI_LIBS_MAC/OrangeExtensions.jar AppleJavaExtensions

# jitsi videobridge libs
install_lib $JVB_LIBS/whack.jar whack
install_lib $JVB_LIBS/xpp3.jar xpp3
install_lib $JVB_LIBS/jitsi-android-osgi.jar osgi-android
install_lib $JVB_LIBS/sigar.jar sigar 1.6.4

# jitsi bundles
build_jitsi
install_bundle util
install_bundle configuration
install_bundle sysactivitynotifications
install_bundle dnsservice
install_bundle neomedia
install_bundle credentialsstorage
install_bundle addrbook
install_bundle certificate
install_bundle smacklib
install_bundle customavatar-service
install_bundle ui-service
install_bundle argdelegation-service
install_bundle googlecontacts-service
install_bundle globaldisplaydetails
install_bundle hid-service
install_bundle resourcemanager

