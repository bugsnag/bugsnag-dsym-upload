#!/usr/bin/env bash
set -euo pipefail

# Requires: curl, jq

OWNER="bugsnag"
REPO="bugsnag-cli"

echo "Fetching latest release info..."
release_json="$(curl -s "https://api.github.com/repos/${OWNER}/${REPO}/releases/latest")"

echo "Parsing asset list..."
assets=$(echo "$release_json" | jq -r '.assets[] | select(.name | test("source\\.zip$|source\\.tar\\.gz$") | not) | [.name, .browser_download_url] | @tsv')

pwd

cd tools/fastlane-plugin/bin

echo "$assets" | while IFS=$'\t' read -r name url; do
  echo "Downloading $name..."
  curl -LO "$url"
done

echo "All done! Files saved in $(pwd)"