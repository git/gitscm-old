#!/bin/sh

SCRIPT=$(readlink -f $0)
SCRIPTPATH=$(dirname $SCRIPT)
authors="$SCRIPTPATH/../config/authors.txt"

git_dir=
schacon=/Users/schacon/projects/git/.git
test -n "$GIT_DIR" && git_dir="$GIT_DIR"
test -d $schacon && git_dir=$schacon

if ! test -d "$git_dir"
then
    echo "You must supply GIT_DIR with a path to the git.git repository"
    exit 1
fi

git --git-dir="$git_dir" \
    log --pretty=short --no-merges \
    origin/maint \
    | git shortlog -n \
    | grep -v -e '^ ' \
    | grep ':' \
    > $authors
