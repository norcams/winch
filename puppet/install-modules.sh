#!/bin/bash
# Reads modules.txt and does git clone and checkout for
# each module referenced
#
# WARNING: Intentionally no recursive submodules support!
set -e

install="modules"
script="$(basename $0)"
currentdir="$PWD"

mkdir -p $install

while read -a line
do
  # Skip comments
  [[ "$line" =~ ^#.*$ ]] && continue

  repo=${line[0]}
  module=${line[1]}
  ref=${line[2]}

  cd $install

  if [ ! -d $module ]; then
    echo "[$script][$module] Cloning from $repo"
    git clone --quiet $repo $module
    echo "[$script][$module] Checking out $ref"
    cd $module && git checkout --quiet $ref
  fi

  cd $currentdir

done < modules.txt

