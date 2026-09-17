#!/usr/bin/env bash
# BUILD DOCS SITE

#
# Copyright 2026 JDHeim.com
# SPDX-License-Identifier: Apache-2.0
#

source "$(dirname "${BASH_SOURCE[0]}")/common/functions.sh"

usage() {
  cat << EOF
Usage: $(basename "$0") [OPTION]...

Build Docs Site
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
  build
}

build() {
  step "Build Docs Site"
  (
    cd "${PROJECT_DIR}"
    run uv run zensical build --strict
  )
}

readOptions "$@"
main
