#!/bin/bash

# Function to check full sudo privileges
has_full_sudo() {
    # Run sudo -l, suppress errors, and grep for the patterns indicating full privileges
    local output=$(sudo -l 2>/dev/null | grep -E '(ALL : ALL) ALL|(ALL) NOPASSWD: ALL')

    # If either pattern is found, return success
    [[ -n $output ]] && return 0 || return 1
}

# Check if the user has full sudo privileges
if has_full_sudo; then
    echo "The user $(whoami) has full sudo privileges."
fi