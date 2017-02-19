#!/bin/bash
set -e
if [ -z "$1"  ]; then
  echo "Missing file path!"
  exit 1
fi

INVOCATION_SOURCE=`pwd`
echo "$INVOCATION_SOURCE"

SCRIPT_SOURCE="$( dirname "${BASH_SOURCE[0]}" )"
echo "$SCRIPT_SOURCE"

echo "~ Generating Seeds ~"
cd $SCRIPT_SOURCE
bundle install --quiet
bundle exec rake generate[$1]

cd $INVOCATION_SOURCE
echo "All done!"
