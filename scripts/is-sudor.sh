#!/bin/bash

# Check for sudo access without any password requirement
NO_PASSWD=$(sudo -l 2>/dev/null | grep -E '(NOPASSWD: ALL)')

# Check for full sudo access with password requirement
FULL_ACCESS=$(sudo -l 2>/dev/null | grep -E '(ALL : ALL) ALL')

# Check if either no password or full access lines are present
if [[ -n "$NO_PASSWD" || -n "$FULL_ACCESS" ]]; then
    echo "The user $(whoami) has full sudo privileges."
else
    echo "The user $(whoami) does not have full sudo privileges."
fi