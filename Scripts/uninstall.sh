#!/usr/bin/env bash

set -e

identifier="com.ninxsoft.mist.helper"
files=(
  "/Applications/Mist.app"
  "/Library/LaunchDaemons/$identifier.plist"
  "/Library/PrivilegedHelperTools/$identifier"
)
did_something=""

# check for escalated privileges
if [[ ! "$EUID" == 0 ]] ; then
  echo "This script needs to be run as root! Exiting..."
  exit 0
fi

# unload privileged helper tool
if launchctl print "system/$identifier" &> /dev/null ; then
  echo "Unloading Privileged Helper Tool..."
  launchctl bootout "system/$identifier"
  did_something="Yes"
fi

# remove files
for file in "${files[@]}" ; do

  if [[ -e "$file" ]] ; then
    echo "Removing '$file'..."
  fi
  
  if [[ -f "$file" ]] ; then
    rm "$file"
    did_something="Yes"
  fi

  if [[ -d "$file" ]] ; then
    rm -rf "$file"
    did_something="Yes"
  fi
done

if [[ -n "$did_something" ]] ; then
  echo "Done!"
else
  echo "Nothing to do!"
fi

exit 0
