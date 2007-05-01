#!/bin/sh

set -e

export PATH=/home/pasky/bin:$PATH

cd /home/pasky/WWW/git

export GIT_DIR=/srv/git/git.git
ver=$(git describe maint | cut -d - -f 1)
time=$(git cat-file tag $ver | sed -n 's/^tagger.*> //p' | cut -d ' ' -f 1)
export -n GIT_DIR

verno=$(echo $ver | sed s/^v//)
date=$(date +%F -d "1970-01-01 0:0 + $time seconds")

oldver=$(sed -n 's/.*@VNUM@-->\([^<]*\)<.*/\1/p' index.html)
[ "$oldver" = "$ver" ] && exit

echo "$oldver -> $ver ($verno, $date)"
echo
sed -i -e '
s/\(@DATE@-->\[\)[^]]*/\1'$date'/
s/\(@VNUM@-->\)[^<]*/\1'$ver'/
s/\(@TARLINK@-->.*git-\).*\(\.tar\)/\1'$verno'\2/
' index.html
echo
cat index.html
echo
cg commit -m"Automated update: [$date] $oldver -> $ver"
cg push origin
