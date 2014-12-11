#!/bin/sh -e

ARTIFACT_ID=$1

mkdir $ARTIFACT_ID
cd $ARTIFACT_ID
git init
git config core.sparsecheckout true
echo src/${ARTIFACT_ID//\./\/} >> .git/info/sparse-checkout
git remote add -f origin git@github.com:/jitsi/jitsi.git
git pull origin master
git branch --set-upstream master origin/master
cat ../depot_tools/pom.xml | sed -e "s/ARTIFACT_ID/$ARTIFACT_ID/" > pom.xml
