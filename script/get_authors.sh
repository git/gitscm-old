#!/bin/sh

SCRIPT=$(readlink -f $0)
SCRIPTPATH=$(dirname $SCRIPT)
authors="$SCRIPTPATH/../config/authors.txt"
relfile="$SCRIPTPATH/../config/release.txt"

git_dir=
schacon=/Users/schacon/projects/git/.git
test -n "$GIT_DIR" && git_dir="$GIT_DIR"
test -d $schacon && git_dir=$schacon

if ! test -d "$git_dir"
then
    echo "You must supply GIT_DIR with a path to the git.git repository"
    exit 1
fi

release=$(git --git-dir="$git_dir" describe origin/maint)
release=${release%%-*}
echo $release > $relfile
git --git-dir="$git_dir" \
    log --pretty=short --no-merges \
    $release \
    | git shortlog -n \
    | grep -v -e '^ ' \
    | grep ':' \
    > $authors
