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
readonly FEDORA4_DOWNLOAD_URL="https://github.com/fcrepo4/fcrepo4/releases/download/fcrepo-4.7.5/fcrepo-webapp-4.7.5.war"
readonly FEDORA4_MD5_HASH="97f265441da5641baa1a8df73ae77765"
readonly FEDORA4_FILE_LOCATION="$SCRIPT_DIR/roles/fedora4/files/fcrepo-webapp-4.7.5.war"

# Solr 7 constants
readonly SOLR7_DOWNLOAD_URL="https://mirror.csclub.uwaterloo.ca/apache/lucene/solr/7.4.0/solr-7.4.0.tgz"
readonly SOLR7_SHA1_HASH="18ac829bcda555de3ff679a0ccd4e263ed9d49a8"
readonly SOLR7_FILE_LOCATION="$SCRIPT_DIR/roles/solr/files/solr-7.4.0.tgz"


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
  local hash_function="$1"
  local file_location="$2"
  local expected_hash="$3"
  local current_hash

  if [ "$hash_function" == "md5" ]; then
      current_hash=$(md5sum $file_location | cut -d ' ' -f 1)
  elif [ "$hash_function" == "sha1" ]; then
      current_hash=$(sha1sum $file_location | cut -d ' ' -f 1)
  else
      err "Error - Unexpected hash function $hash_function."
  fi

  if [ ! "$current_hash" == "$expected_hash" ]; then
      err "Error - File at $1 has the wrong $hash_function hash. It is recommended that the file be deleted and re-downloaded. Got $current_hash, expected $expected_hash."
  fi
}

# Check that a executable is available for use.
check_command_exists(){
  local command_name="$1"
  if ! [ -x "$(command -v $command_name)" ]; then
    err "$command_name does not exist or is not executable."
  fi
}

# Download a file and verify its integrity.
# Arguments:
#  file_location
#  download_url
#  hash_function
#  expected_hash
download_and_verify() {
  local file_location="$1"
  local download_url="$2"
  local hash_function="$3"
  local expected_hash="$4"
  if [ ! -f $file_location ]; then
    echo "$file_location does not exist, downloading from $download_url"
    curl --silent --show-error -L $download_url --output $file_location
  fi
  check_hash_match $hash_function $file_location $expected_hash
}

main() {
  check_command_exists curl
  download_and_verify $FEDORA4_FILE_LOCATION $FEDORA4_DOWNLOAD_URL md5 $FEDORA4_MD5_HASH
  download_and_verify $SOLR7_FILE_LOCATION $SOLR7_DOWNLOAD_URL sha1 $SOLR7_SHA1_HASH
}
main

