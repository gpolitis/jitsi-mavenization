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

# don't link to a configured bare repository
isbare=$(git --git-dir="$git_dir" config --bool --get core.bare)
if test ztrue = z$isbare
then
	die "\"$git_dir\" has core.bare set to true," \
		" remove from \"$git_dir/config\" to use $0"
fi

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

# create the links to the original repo.  explicitly exclude index, HEAD and
# logs/HEAD from the list since they are purely related to the current working
# directory, and should not be shared.
for x in config refs logs/refs objects info hooks packed-refs remotes rr-cache svn
do
	case $x in
	*/*)
		mkdir -p "$(dirname "$artifact_id/.git/$x")"
		;;
	esac
	ln -s "$git_dir/$x" "$artifact_id/.git/$x"
done

# now setup the workdir
cd "$artifact_id"

# copy the HEAD from the original repository as a default branch
cp "$git_dir/HEAD" .git/HEAD

# configure the sparse checkout
git config core.sparsecheckout true
sparse_checkout="$script_path/artifacts/$artifact_id/git-sparse-checkout"
if [ ! -f "$sparse_checkout" ]; then
	mkdir -p `dirname "$sparse_checkout"`
	echo src/${artifact_id//\./\/} > "$sparse_checkout"
	vim .git/info/sparse-checkout
fi

if [ -f .git/info/sparse-checkout ]; then 
	rm .git/info/sparse-checkout
fi

ln -s "$sparse_checkout" .git/info/sparse-checkout

# checkout the branch (either the same as HEAD from the original repository, or
# the one that was asked for)
git checkout -f $branch

# add initial pom.xml
pom_path="$script_path/artifacts/$artifact_id/pom.xml"
if [ ! -f "$pom_path" ]; then
	cat "$script_path/pom.xml.in" | sed -e "s/ARTIFACT_ID/$artifact_id/" > "$pom_path"
fi

ln -s "$pom_path" pom.xml
