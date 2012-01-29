#! /usr/bin/env bash
set -e

version() {
  echo "git-autobisect 0.1.0"
}

usage(){
  echo "Find the first broken commit without having to learn git bisect

Usage:
    git-autobisect command-with-non-0-exit-status

Options:
    -v, --version                    Show Version
    -h, --help                       Show this.
"
}

if [ "$1" = "-v" ] || [ "$1" = "--version" ]; then
  version
  exit 0
fi

if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$1" = "" ]; then
  usage
  exit 0
fi

# stop if current commit is ok
eval "$@" && (echo "current commit is not broken" && exit 1)

# save current as $bad
bad=$(git log --pretty=format:'%h' | head -1)

# find the first good commit
commits=$(git log --pretty=format:'%h' | tail -n +2) # all but current commit

for commit in $commits
do
  echo Now trying $commit
  git checkout $commit
  eval "$@" && good=$commit
done

# bisect if we found a good commit
if [ "$good" != "" ]; then
  git bisect start
  git checkout $bad
  git bisect bad
  git checkout $good
  git bisect good
  git bisect run eval "$@"
else
  # otherwise give up
  echo "no commit works" && exit 1
fi