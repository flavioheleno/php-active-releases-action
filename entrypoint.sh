#!/bin/sh

set -o errexit
set -o noglob
set -o nounset

wget \
  --quiet \
  --tries=3 \
  --output-document=php.json \
  --waitretry=1 \
  --unlink \
  --compression=auto \
  "https://www.php.net/releases/active.php" \
  && EXIT_CODE=$? || EXIT_CODE=$?

if [ "${EXIT_CODE}" -ne 0 ]; then
  echo "Failed to download release list" >> "$GITHUB_STEP_SUMMARY"

  exit "${EXIT_CODE}"
fi


jq --compact-output '. | keys' php.json > major.json 2> /dev/null \
&& EXIT_CODE=$? || EXIT_CODE=$?
if [ "${EXIT_CODE}" -ne 0 ]; then
  echo "Failed to extract major version list" >> "$GITHUB_STEP_SUMMARY"

  exit "${EXIT_CODE}"
fi

echo "major=$(cat major.json)" >> "$GITHUB_OUTPUT"

jq --compact-output '.[] | keys' php.json > minor.json 2> /dev/null \
&& EXIT_CODE=$? || EXIT_CODE=$?
if [ "${EXIT_CODE}" -ne 0 ]; then
  echo "Failed to extract minor version list" >> "$GITHUB_STEP_SUMMARY"

  exit "${EXIT_CODE}"
fi

echo "minor=$(cat minor.json)" >> "$GITHUB_OUTPUT"

jq --compact-output '[ .[][].version ]' php.json > patch.json 2> /dev/null \
&& EXIT_CODE=$? || EXIT_CODE=$?
if [ "${EXIT_CODE}" -ne 0 ]; then
  echo "Failed to extract patch version list" >> "$GITHUB_STEP_SUMMARY"

  exit "${EXIT_CODE}"
fi

echo "patch=$(cat patch.json)" >> "$GITHUB_OUTPUT"

jq --compact-output '[ .[][] | { version: .version } + .source[0] ]' php.json > release.json 2> /dev/null \
&& EXIT_CODE=$? || EXIT_CODE=$?
if [ "${EXIT_CODE}" -ne 0 ]; then
  echo "Failed to extract release list" >> "$GITHUB_STEP_SUMMARY"

  exit "${EXIT_CODE}"
fi

echo "release=$(cat release.json)" >> "$GITHUB_OUTPUT"
