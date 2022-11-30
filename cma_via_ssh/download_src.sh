#!/usr/bin/env bash
# Script to download asset file from tag release using GitHub API v3.
# See: http://stackoverflow.com/a/35688093/55075    
CWD="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"

# Check dependencies.
set -e
type curl grep sed tr >&2
xargs=$(which gxargs || which xargs)

CURL_ARGS="-J"
GITHUB_API_TOKEN='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'
proxy_set="http://constr:constr@192.168.120.234:3128"
# Validate settings.
[ -f ~/.secrets ] && source ~/.secrets
[ "$GITHUB_API_TOKEN" ] || { echo "Error: Please define GITHUB_API_TOKEN variable." >&2; exit 1; }
[ $# -ne 4 ] && { echo "Usage: $0 [owner] [repo] [branch] [target]"; exit 1; }
[ "$TRACE" ] && set -x
read owner repo branch target <<<$@

# Define variables.
GH_API="https://api.github.com"
GH_REPO="$GH_API/repos/$owner/$repo"
GH_ZIPBALL="$GH_REPO/tarball/$branch"

# Download asset file.
echo "Downloading asset from \"$GH_ZIPBALL\" ..." >&2
echo -e "\tto \"$target\"" >&2
curl $CURL_ARGS \
    --location --max-redirs 10 \
    --progress-bar \
    --proxy $proxy_set \
    -u 'a.givertzman@icloud.com' \
    -H 'Accept: application/vnd.github+json' \
    "$GH_ZIPBALL" > $target
    # -H "Authorization: token $GITHUB_API_TOKEN" \
echo "$0 done." >&2