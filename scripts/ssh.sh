#!/bin/bash

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
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bk

# Enable public key authentication
sudo sed -i 's/^#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/^PubkeyAuthentication no/PubkeyAuthentication yes/' /etc/ssh/sshd_config

# Disable password authentication
sudo sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# Ensure empty passwords are not allowed
sudo sed -i 's/^#PermitEmptyPasswords yes/PermitEmptyPasswords no/' /etc/ssh/sshd_config
sudo sed -i 's/^PermitEmptyPasswords yes/PermitEmptyPasswords no/' /etc/ssh/sshd_config

if prompt_yes_no "Block 'root' user to login?"; then

    # Check if the current user is root; if yes, exit with an error
    if [[ $(id -u) -eq 0 ]]; then
        echo "This script should not be run as `root`. Please run as a different user with sudo privileges."
        exit 1
    fi

    #!/bin/bash

    # Check for sudo access without any password requirement
    NO_PASSWD=$(sudo -l 2>/dev/null | grep -E '(NOPASSWD: ALL)')

    # Check for full sudo access with password requirement
    FULL_ACCESS=$(sudo -l 2>/dev/null | grep -E '(ALL : ALL) ALL')

    # Check if either no password or full access lines are present
    if [[ -n "$NO_PASSWD" || -n "$FULL_ACCESS" ]]; then
        echo "\u2713 The user $(whoami) has full sudo privileges. Continue .."
    else
        echo "The user $(whoami) does not have full sudo privileges. Run the script with a user with full sudo privileges."
        exit 1
    fi

    # Disable login for root user
    sudo sed -i 's/^#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
    sudo sed -i 's/^PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
    sudo sed -i 's/^PermitRootLogin without-password/PermitRootLogin no/' /etc/ssh/sshd_config
    # Disable login for root user even with Public key
    sudo sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
    sudo sed -i 's/^PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
fi

sudo sshd -t

# Restart to apply changes
sudo service sshd restart

echo "SSH has been secured."