#!/usr/bin/env bash
# SERVE DOCS SITE LOCALLY

#
# Copyright 2026 JDHeim.com
# SPDX-License-Identifier: Apache-2.0
#

source "$(dirname "${BASH_SOURCE[0]}")/common/functions.sh"

readonly ADDRESS="0.0.0.0:80"

usage() {
  cat << EOF
Usage: $(basename "$0") [OPTION]...

Serve Docs Site Locally
EOF
  return 1
}

readOptions() {
  while (( $# > 0 )); do
    case "${1}" in
      *) usage ;;
    esac
    shift
  done
}

main() {
  requireCommand uv
  serve
}

serve() {
  step "Run Docs Site Locally"
  (
    cd "${PROJECT_DIR}"
    run uv run zensical serve --dev-addr "${ADDRESS}"
  )
}

readOptions "$@"
main
