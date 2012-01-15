#! /usr/bin/env bash
set -e

version() {
  echo "git-autobisect 0.1.0"
}

usage(){
  echo "Usage"
}

if [ "$1" = "-v" ] || [ "$1" = "--version" ]; then
  version
  exit 0
fi

if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$1" = "" ]; then
  usage
  exit 0
fi
