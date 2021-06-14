#!/usr/bin/env bash
set -exuo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${SCRIPT_DIR}/deploy-shared.source"

if [[ $# -lt 1 ]] ; then
    echo "Syntax: $0 <tag> <site>"
    exit 1
fi
TAG=$1
SITE=$2

cd "${SCRIPT_DIR}/.."

# Deploy site
sync "env-webmaster-${SITE}"
deploy "env-webmaster-${SITE}" "webmaster" "${TAG}"

