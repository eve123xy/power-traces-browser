#!/bin/bash
# Run this once you're back with a valid GitHub PAT (fine-grained, Contents: R/W
# on eve123xy/power-traces-browser). Revoke the token right after it runs.
#
# Usage:
#   GH_TOKEN=github_pat_xxx ./PUSH_WHEN_BACK.sh
# or just edit the line below and run it directly.

set -euo pipefail
cd "$(dirname "$0")"

TOKEN="${GH_TOKEN:-REPLACE_WITH_YOUR_TOKEN}"
if [ "$TOKEN" = "REPLACE_WITH_YOUR_TOKEN" ]; then
  echo "Set GH_TOKEN env var or edit this script with your PAT before running." >&2
  exit 1
fi

# NOTE: "eve123xy:${TOKEN}@github.com" (user:pass URL auth) fails with
# "Invalid username or token" for fine-grained PATs on this repo -- use an
# auth header instead, which also keeps the token out of the process args
# (ps/history) more reliably than embedding it in the remote URL.
git -c http.extraHeader="AUTHORIZATION: Basic $(printf 'x-access-token:%s' "$TOKEN" | base64 -w0)" \
    push https://github.com/eve123xy/power-traces-browser.git main
echo "Pushed. Now revoke the token at https://github.com/settings/tokens"
