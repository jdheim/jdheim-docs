#!/usr/bin/env bash
# COMMON FUNCTIONS

#
# Copyright 2026 JDHeim.com
# SPDX-License-Identifier: Apache-2.0
#

set -o errexit  # ABORT ON NON-ZERO EXIT STATUS
set -o nounset  # TREAT UNSET VARIABLES AS AN ERROR AND EXIT
set -o pipefail # DON'T HIDE ERRORS WITHIN PIPES

if [[ -n "${FUNCTIONS_LOADED:-}" ]]; then
  return 0
fi
declare -r FUNCTIONS_LOADED="true"

# Common constants
declare -rx EDITOR="idea --wait"

# Common paths
COMMON_SCRIPTS_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$(cd -- "${COMMON_SCRIPTS_DIR}/.." && pwd)"
PROJECT_DIR="$(cd -- "${SCRIPTS_DIR}/.." && pwd)"
declare -rx COMMON_SCRIPTS_DIR SCRIPTS_DIR PROJECT_DIR

# Terminal colors
if [[ -t 1 ]]; then
  declare -rx CYAN=$'\e[1;96m'
  declare -rx BLUE=$'\e[1;34m'
  declare -rx GREEN=$'\e[1;32m'
  declare -rx YELLOW=$'\e[1;33m'
  declare -rx YELLOW_DARK=$'\e[0;33m'
  declare -rx RED=$'\e[1;31m'
  declare -rx BOLD=$'\e[1m'
  declare -rx RESET=$'\e[0m'
else
  declare -rx CYAN=""
  declare -rx BLUE=""
  declare -rx GREEN=""
  declare -rx YELLOW=""
  declare -rx YELLOW_DARK=""
  declare -rx RED=""
  declare -rx BOLD=""
  declare -rx RESET=""
fi

# General functions

step() {
  log "STEP" "${CYAN}" "${BOLD}${1}${RESET}"
}

info() {
  log "INFO" "${BLUE}" "${1}"
}

warn() {
  log "WARN" "${YELLOW}" "${1}"
}

error() {
  log "ERROR" "${RED}" "${1}"
}

run() {
	logCommand "$@"; "$@"
}

runQuiet() {
  logCommand "$@"; "$@" >/dev/null
}

runSilent() {
  logCommand "$@"; "$@" &>/dev/null
}

logCommand() {
  local formattedCmd
  formattedCmd="$(printf '%q ' "$@")"
  log "CMD" "${BLUE}" "${formattedCmd}"
}

log() {
  local logLevel="${1}"
  local logLevelColor="${2}"
  local logMessage="${3}"
  local logSymbol="[${logLevelColor}${logLevel}${RESET}]"
  if [[ "${logLevel}" == "STEP" ]]; then
    local stepSeparator="${CYAN}===${RESET}"
    printf '%b %b %s %b\n' "${logSymbol}" "${stepSeparator}" "${logMessage}" "${stepSeparator}" >&2
  else
    printf '%b %s\n' "${logSymbol}" "${logMessage}" >&2
  fi
}

trim() {
  local string="${1}"
  string="${string#"${string%%[![:space:]]*}"}"
  string="${string%"${string##*[![:space:]]}"}"
  printf '%s\n' "${string}"
}

# General validations

requireFile() {
  local path="${1}"
  if [[ ! -f "${path}" ]]; then
    error "The \"${path}\" file does not exist"
    exit 1
  fi
}

requireDir() {
  local path="${1}"
  if [[ ! -d "${path}" ]]; then
    error "The \"${path}\" directory does not exist"
    exit 1
  fi
}

requireCommand() {
  local command="${1}"
  if ! command -v "${1}" &>/dev/null; then
    error "The \"${command}\" command not found"
    exit 1
  fi
}
