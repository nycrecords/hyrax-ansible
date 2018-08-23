#! /usr/bin/env bash
#
# This script downloads any necessary files to the roles subdirectories.
# This script should follow the Google shell styleguide.

# Exit on error. Append "|| true" if you expect an error.
set -o errexit
# Exit on error inside any functions or subshells.
set -o errtrace
# Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
set -o nounset
# Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump |gzip`
set -o pipefail
# Turn on traces, useful while debugging but commented out by default
# set -o xtrace

# The directory which contains the script.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
readonly SCRIPT_DIR

# Fedora 4 constants
readonly FEDORA4_WAR_FILE="fcrepo-webapp-4.7.5.war"
readonly FEDORA4_DOWNLOAD_URL="https://github.com/fcrepo4/fcrepo4/releases/download/fcrepo-4.7.5/fcrepo-webapp-4.7.5.war"
readonly FEDORA4_MD5_HASH="97f265441da5641baa1a8df73ae77765"
readonly FEDORA4_WAR_FILE_LOCATION="$SCRIPT_DIR/roles/fedora4/files/$FEDORA4_WAR_FILE"

# Print message to stderr and exit
err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@" >&2
  exit 1
}

# Check that a file has the expected MD5 hash.
# This function will exit if the file at file_location doesn't have a matching
# MD5 checksum.
# Arguments:
#  file_location
#  expected_hash
check_hash_match() {
  local file_location="$1"
  local expected_hash="$2"
  local current_hash
  current_hash=$(md5sum $1 | cut -d ' ' -f 1)
  if [ ! "$current_hash" == "$expected_hash" ]; then
      err "Error - File at $1 has the wrong MD5 hash. It is recommended that the file be deleted and re-downloaded. Got $current_hash, expected $expected_hash."
  fi
}

# Check that a executable is available for use.
check_command_exists(){
  local command_name="$1"
  if ! [ -x "$(command -v $command_name)" ]; then
    err "$command_name does not exist or is not executable."
  fi
}

# Download any files required by the fedora4 role
prepare_fedora4_role() {
  if [ ! -f $FEDORA4_WAR_FILE_LOCATION ]; then
    echo "$FEDORA4_WAR_FILE does not exist in the expected location, downloading from $FEDORA4_DOWNLOAD_URL"
    curl -L $FEDORA4_DOWNLOAD_URL --output $FEDORA4_WAR_FILE_LOCATION
  fi
  check_hash_match $FEDORA4_WAR_FILE_LOCATION $FEDORA4_MD5_HASH
}

main() {
  check_command_exists curl
  prepare_fedora4_role
}
main

