#!/bin/sh -e

# for later use
script_path=$( cd $(dirname $0) ; pwd -P )

usage () {
	echo "usage:" $@
	exit 127
}

die () {
	echo $@
	exit 128
}

if test $# -lt 2 || test $# -gt 3
then
	usage "$0 <repository> <artifact_id> [<branch>]"
fi

jitsi_git=$1
artifact_id=$2
branch=$3

# want to make sure that what is pointed to has a .git directory ...
git_dir=$(cd "$jitsi_git" 2>/dev/null &&
  git rev-parse --git-dir 2>/dev/null) ||
  die "Not a git repository: \"$jitsi_git\""

case "$git_dir" in
.git)
	git_dir="$jitsi_git/.git"
	;;
.)
	git_dir=$jitsi_git
	;;
esac

# don't link to a workdir
if test -h "$git_dir/config"
then
	die "\"$jitsi_git\" is a working directory only, please specify" \
		"a complete repository."
fi

# don't recreate a workdir over an existing repository
if test -e "$artifact_id"
then
	die "destination directory '$artifact_id' already exists."
fi

# make sure the links use full paths
git_dir=$(cd "$git_dir"; pwd)

# create the workdir
mkdir -p "$artifact_id/.git" || die "unable to create \"$artifact_id\"!"

# now setup the workdir
cd "$artifact_id"

# share objects
git init
mkdir -p ".git/objects/info/" || die "unable to create \"$artifact_id\"!"
rm -rf .git/config
ln -s "$git_dir/config" .git/config
echo "$git_dir/objects" > .git/objects/info/alternates

# copy the HEAD from the original repository as a default branch
cp "$git_dir/HEAD" .git/HEAD

# configure the sparse checkout
git config core.sparsecheckout true
sparse_checkout="$script_path/artifacts/$artifact_id/git-sparse-checkout"
if [ ! -f "$sparse_checkout" ]; then
	mkdir -p `dirname "$sparse_checkout"`
	echo src/${artifact_id//\./\/} > "$sparse_checkout"
	vim "$sparse_checkout"
fi

ln -s "$sparse_checkout" .git/info/sparse-checkout

# checkout the branch (either the same as HEAD from the original repository, or
# the one that was asked for)
git pull origin $branch

# add initial pom.xml
pom_path="$script_path/artifacts/$artifact_id/pom.xml"
if [ ! -f "$pom_path" ]; then
	cat "$script_path/pom.xml.in" | sed -e "s/ARTIFACT_ID/$artifact_id/" > "$pom_path"
fi

ln -s "$pom_path" pom.xml
