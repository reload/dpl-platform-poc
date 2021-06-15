#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${SCRIPT_DIR}/deploy-shared.source"

if [[ $# -lt 1 ]] ; then
    echo "Syntax: $0 <tag>"
    exit 1
fi
TAG=$1

cd "${SCRIPT_DIR}/.."

# Iterate sites.
while read site; do
  sync "redak-${site}"
  deploy "redak-${site}" "core" "${TAG}"
done <editor-sites.txt
