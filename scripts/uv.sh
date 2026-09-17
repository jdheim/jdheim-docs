#!/usr/bin/env bash
# UV MANAGEMENT

#
# Copyright 2026 JDHeim.com
# SPDX-License-Identifier: Apache-2.0
#

source "$(dirname "${BASH_SOURCE[0]}")/common/functions.sh"

UV_SUBCOMMAND=()

usage() {
  cat << EOF
Usage: $(basename "$0") [OPTION]...

UV Management

OPTIONS:
  -s, --sync            Update the project's environment
EOF
  return 1
}

readOptions() {
  if (( $# == 0 )); then
    usage
  fi
  while (( $# > 0 )); do
    case "${1}" in
      -s|--sync) UV_SUBCOMMAND=("sync") ;;
      -h|--help) usage ;;
      *) UV_SUBCOMMAND=("$@")
    esac
    shift
  done
}

main() {
  step "UV Management"
  (
    cd "${PROJECT_DIR}"
    run uv "${UV_SUBCOMMAND[@]}"
  )
}

readOptions "$@"
main
