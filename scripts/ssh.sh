#!/bin/bash

# Ensure just root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

prompt_yes_no() {
    while true; do
        # Ask the user
        read -rp "$1 [Y/n]: " answer

        # Default to Yes if no answer is given.
        if [[ -z $answer ]]; then
            answer="N"
        fi

        # Check the answer
        case "$answer" in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

# Backup the SSH configuration
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bk

# Enable public key authentication
sed -i 's/^#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^PubkeyAuthentication no/PubkeyAuthentication yes/' /etc/ssh/sshd_config

# Disable password authentication
sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# Ensure empty passwords are not allowed
sed -i 's/^#PermitEmptyPasswords yes/PermitEmptyPasswords no/' /etc/ssh/sshd_config
sed -i 's/^PermitEmptyPasswords yes/PermitEmptyPasswords no/' /etc/ssh/sshd_config

if prompt_yes_no "Block 'root' user to login?"; then
   # Disable root SSH login
   sed -i 's/^#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
   sed -i 's/^PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
   sed -i 's/^PermitRootLogin without-password/PermitRootLogin no/' /etc/ssh/sshd_config
fi

sudo sshd -t

# Restart to apply changes
service sshd restart

echo "SSH has been secured."