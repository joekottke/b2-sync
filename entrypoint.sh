#!/bin/bash

set -e

# is_set <variable name>
# check to see if required variable has a value
is_set()
{
    var_name="${1}"
    if [[ -z "${!var_name}" ]]
    then
        echo "${var_name} is not set."
        exit 1
    fi
}

is_set B2_SYNC_APPLICATION_KEY_ID
is_set B2_SYNC_APPLICATION_KEY
export B2_APPLICATION_KEY_ID="${B2_SYNC_APPLICATION_KEY_ID}"
export B2_APPLICATION_KEY="${B2_SYNC_APPLICATION_KEY}"

if [[ -z "${B2_SYNC_DESTINATION}" && -z  "${B2_SYNC_SOURCE}" ]]
then
    echo "Either B2_SYNC_SOURCE or B2_SYNC_DESTINATION must be set"
    exit 1
fi

source="/source"
if [[ -n "${B2_SYNC_SOURCE}" ]]
then
    source="${B2_SYNC_SOURCE}"
fi

destination="/destination"
if [[ -n "${B2_SYNC_DESTINATION}" ]]
then
    destination="${B2_SYNC_DESTINATION}"
fi

b2_prefix="b2://"
if [[ "${source}" != "${b2_prefix}"* && "${destination}" != "${b2_prefix}"* ]]
then
    echo "${source} ${destination}"
    echo "Either B2_SYNC_SOURCE or B2_SYNC_DESTINATION must be a B2 Bucket URL that starts with \"b2://\""
    exit 1
fi

dry_run=""
if [[ -n "${B2_SYNC_DRY_RUN}" ]]
then
    dry_run="--dry-run"
fi

threads=""
if [[ -n "${B2_SYNC_THREADS}" ]]
then
    threads="--threads ${B2_SYNC_THREAD_COUNT}"
fi

if [[ -n "${B2_SYNC_SHOW_BUCKET_LIST}" ]]
then
    echo "-- Showing bucket list"
    /usr/local/bin/b2 bucket list
fi

cmd="/usr/local/bin/b2 sync ${dry_run} ${threads} ${source} ${destination}"
echo "-- Syncing with command: ${cmd}"
exec ${cmd}
