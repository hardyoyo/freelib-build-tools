#! /bin/bash

#
# A simple script to publish our artifacts on a push to the "master" branch.
# Publishes snapshots or, if our version isn't a snapshot, stable artifacts.
#

# Get the directory from which this script is running
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [[ "$TRAVIS_PULL_REQUEST" == "false" && ("$TRAVIS_BRANCH" == "TRAVIS_TAG" || "$TRAVIS_BRANCH" == "master") ]]; then
  # Find the settings file that we'll use to release
  SETTINGS_FILE=$(find . -name settings.xml | grep -v target)

  # Add the release key we'll use to publish through Sonatype
  gpg --import src/main/resources/build-key.gpg

  # If we have a tag, we're doing a real release
  if [[ "$TRAVIS_BRANCH" == "TRAVIS_TAG" ]]; then
    mvn -q versions:set -DnewVersion="${TRAVIS_TAG}"
  fi

  "$DIR/release" "$SETTINGS_FILE"
  "$DIR/release" "$SETTINGS_FILE" | grep Uploaded.*jar
fi
