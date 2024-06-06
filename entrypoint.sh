#!/bin/sh

set -o errexit
set -o noglob
set -o nounset

curl \
  --fail \
  --output php.json \
  --silent \
  "https://www.php.net/releases/active.php" \
  && EXIT_CODE=$? || EXIT_CODE=$?

if [ "${EXIT_CODE}" -ne 0 ]; then
  echo "Failed to download release list" >> "$GITHUB_STEP_SUMMARY"

  exit "${EXIT_CODE}"
fi

########
## MAJOR
########

jq --compact-output '. | keys' php.json > major.json 2> /dev/null \
&& EXIT_CODE=$? || EXIT_CODE=$?
if [ "${EXIT_CODE}" -ne 0 ]; then
  echo "Failed to extract major version list" >> "$GITHUB_STEP_SUMMARY"

  exit "${EXIT_CODE}"
fi

echo "major=$(cat major.json)" >> "$GITHUB_OUTPUT"

########
## MINOR
########

jq --compact-output '.[] | keys' php.json > minor.json 2> /dev/null \
&& EXIT_CODE=$? || EXIT_CODE=$?
if [ "${EXIT_CODE}" -ne 0 ]; then
  echo "Failed to extract minor version list" >> "$GITHUB_STEP_SUMMARY"

  exit "${EXIT_CODE}"
fi

echo "minor=$(cat minor.json)" >> "$GITHUB_OUTPUT"

jq --compact-output '[ .[] | keys | .[] | split(".") | { major: .[0], minor: .[1] } ]' php.json > minor-split.json 2> /dev/null \
&& EXIT_CODE=$? || EXIT_CODE=$?
if [ "${EXIT_CODE}" -ne 0 ]; then
  echo "Failed to extract minor-split version list" >> "$GITHUB_STEP_SUMMARY"

  exit "${EXIT_CODE}"
fi

echo "minor-split=$(cat minor-split.json)" >> "$GITHUB_OUTPUT"

########
## PATCH
########

jq --compact-output '[ .[][].version ]' php.json > patch.json 2> /dev/null \
&& EXIT_CODE=$? || EXIT_CODE=$?
if [ "${EXIT_CODE}" -ne 0 ]; then
  echo "Failed to extract patch version list" >> "$GITHUB_STEP_SUMMARY"

  exit "${EXIT_CODE}"
fi

echo "patch=$(cat patch.json)" >> "$GITHUB_OUTPUT"

jq --compact-output '[ .[][].version | split(".") | { major: .[0], minor: .[1], patch: .[2] } ]' php.json > patch-split.json 2> /dev/null \
&& EXIT_CODE=$? || EXIT_CODE=$?
if [ "${EXIT_CODE}" -ne 0 ]; then
  echo "Failed to extract patch-split version list" >> "$GITHUB_STEP_SUMMARY"

  exit "${EXIT_CODE}"
fi

echo "patch-split=$(cat patch-split.json)" >> "$GITHUB_OUTPUT"

##########
## RELEASE
##########

jq --compact-output '[ .[][] | { version: .version } + .source[0] ]' php.json > release.json 2> /dev/null \
&& EXIT_CODE=$? || EXIT_CODE=$?
if [ "${EXIT_CODE}" -ne 0 ]; then
  echo "Failed to extract release list" >> "$GITHUB_STEP_SUMMARY"

  exit "${EXIT_CODE}"
fi

echo "release=$(cat release.json)" >> "$GITHUB_OUTPUT"
