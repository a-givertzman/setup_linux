#!/usr/bin/env bash
# Script to download asset file from tag release using GitHub API v3.
# See: http://stackoverflow.com/a/35688093/55075    
CWD="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"

# Check dependencies.
set -e
type curl grep sed tr >&2
xargs=$(which gxargs || which xargs)

GITHUB_API_TOKEN='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'
proxy_set="http://constr:constr@192.168.120.234:3128"
# Validate settings.
[ -f ~/.secrets ] && source ~/.secrets
[ "$GITHUB_API_TOKEN" ] || { echo "Error: Please define GITHUB_API_TOKEN variable." >&2; exit 1; }
[ $# -ne 4 ] && { echo "Usage: $0 [owner] [repo] [tag] [asset]"; exit 1; }
[ "$TRACE" ] && set -x
read owner repo tag asset <<<$@

# Define variables.
GH_API="https://api.github.com"
GH_REPO="$GH_API/repos/$owner/$repo"
GH_TAGS="$GH_REPO/releases/tags/$tag"
# AUTH="Authorization: token $GITHUB_API_TOKEN"
AUTH="Authorization: Bearer $GITHUB_API_TOKEN"
WGET_ARGS="--content-disposition --auth-no-challenge --no-cookie"
CURL_ARGS="-LJ"

# Validate token.
curl -o /dev/null -sH "$AUTH" $GH_REPO || { echo "Error: Invalid repo, token or network issue!";  exit 1; }

# Read asset tags.
response=$(curl -sH "$AUTH" $GH_TAGS)
# Get ID of the asset based on given asset name.
eval $(echo "$response" | grep -C3 "name.:.\+$asset" | grep -w id | tr : = | tr -cd '[[:alnum:]]=')
#id=$(echo "$response" | jq --arg name "$asset" '.assets[] | select(.name == $asset).id') # If jq is installed, this can be used instead. 
[ "$id" ] || { echo "Error: Failed to get asset id, response: $response" | awk 'length($0)<100' >&2; exit 1; }
GH_ASSET="$GH_REPO/releases/assets/$id"

# Download asset file.
echo "Downloading asset from \"$GH_ASSET\" ..." >&2
    # -H "Authorization: token $GITHUB_API_TOKEN"
rm -f "/tmp/$asset"
curl $CURL_ARGS \
    --progress-bar \
    --proxy $proxy_set \
    -H "Authorization: Bearer $GITHUB_API_TOKEN" \
    -H 'Accept: application/octet-stream' \
    "$GH_ASSET" > "/tmp/$asset"
echo "$0 done." >&2