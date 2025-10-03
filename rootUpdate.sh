#!/bin/sh

# Path to Unbound's root.hints file on FreeBSD
ROOT_HINTS="/usr/local/etc/unbound/root.hints"
TEMP_FILE="/tmp/root.hints.new"

# Download the latest version of the root.hints file
fetch -o "$TEMP_FILE" https://www.internic.net/domain/named.cache

# Check if the download was successful
if [ $? -ne 0 ]; then
    echo "Error downloading the root.hints file"
    exit 1
fi

# Compare the downloaded file with the existing one
if ! cmp -s "$ROOT_HINTS" "$TEMP_FILE"; then
    echo "The root.hints file has been updated and Unbound reloaded."

    # Replace the root.hints file with the updated version
    mv "$TEMP_FILE" "$ROOT_HINTS"

    # Reload Unbound without clearing the cache
    service unbound reload

else
    echo "No updates available for the root.hints file."
    rm "$TEMP_FILE"
fi