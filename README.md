This is an attempt to mavenize Jitsi and friends. *Everything* is put under the
`org.jitsi` group id. The [artifacts](artifacts/) directory contains poms for bundles that
have already been mavenized. External dependencies are either pulled from
maven, or, if they're not yet mavenized, they're installed in the local
repository so that they can be shared. 

The repository contains three POSIX compliant shell scripts :

- [mvn-extract-artifact.sh](mvn-extract-artifact.sh) : it extracts a bundle
  from the Jitsi codebase. It does a sparse checkout that contains only the
  code for the bundle, isolating it from the Jitsi codebase. To minimize disk
  and network usage, it shares the git objects with a complete Jitsi (SIP
  Communicator) checkout. 

- [mvn-extract-all.sh](mvn-extract-all.sh) : it calls the
  [mvn-extract-artifact.sh](mvn-extract-artifact.sh) for all the mavenized
   bundles in the artifacts directory.

- [mvn-install-deps.sh](mvn-install-deps.sh) : it installs external
  dependencies that are not found in a maven repository to the local maven
  repository.

Maveization of the Jitsi Videobridge and JICOFO is functional, i.e. you can mvn
compile the project. You can also import it in IntelliJ IDEA and it will just
work. I've been trying to mavenize Jitsi (SIP Communicator) and althought I
have done some progress there, it's not yet functional.

This is a work in progress, USE IT AT YOUR OWN RISK. Althought I'm affiliated
with Jitsi, this is not an official effort to mavenize Jitsi, it's just
personal work that I'm sharing with whoever might be interested.

I'm not a maven expert nor a git wizard nor a shell guru, so I expect there's
lots of room for improvements. The code is ugly but it works for me. 
