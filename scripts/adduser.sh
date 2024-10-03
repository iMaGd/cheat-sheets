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

# Prompt for the username
read -p "Enter the new username: " USERNAME

# Check if the username is non-empty
if [[ -z "$USERNAME" ]]; then
    echo "No username entered. Terminated."
    exit 1
fi

# Check if the user already exists
if id "$USERNAME" &>/dev/null; then
    echo "User '$USERNAME' already exists. Exiting."
    exit 1
fi


# Generate a strong password
PASSWORD=$(openssl rand -base64 12)

# Create the user
sudo adduser --disabled-password --gecos "" "$USERNAME"

# Set the password for the user
echo "$USERNAME:$PASSWORD" | sudo chpasswd

# Output the username and password
echo "User '$USERNAME' created with the password '$PASSWORD'"


# Grant user superadmin privileges if 'yes'
if prompt_yes_no "Grant '$USERNAME' Superuser privileges?"; then
    echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/${USERNAME}
    sudo chmod 0440 /etc/sudoers.d/${USERNAME}

    echo "sudoer file added at /etc/sudoers.d/${USERNAME}"
    echo "Superuser privileges added to '$USERNAME' user."

elif prompt_yes_no "Grant '$USERNAME' Moderator privileges?"; then

    # Grant access to LEMP and LAMP stack services
    echo "${USERNAME} ALL=(ALL) NOPASSWD: /usr/sbin/service apache2 *" | sudo tee /etc/sudoers.d/${USERNAME}
    echo "${USERNAME} ALL=(ALL) NOPASSWD: /usr/sbin/service nginx *" | sudo tee /etc/sudoers.d/${USERNAME}
    echo "${USERNAME} ALL=(ALL) NOPASSWD: /usr/sbin/service php*-fpm *" | sudo tee /etc/sudoers.d/${USERNAME}
    echo "${USERNAME} ALL=(ALL) NOPASSWD: /usr/sbin/service mysql *" | sudo tee /etc/sudoers.d/${USERNAME}
    echo "${USERNAME} ALL=(ALL) NOPASSWD: /usr/sbin/service mariadb *" | sudo tee /etc/sudoers.d/${USERNAME}
    echo "${USERNAME} ALL=(ALL) NOPASSWD: /usr/bin/supervisorctl restart horizon" | sudo tee /etc/sudoers.d/${USERNAME}

    sudo chmod 0440 /etc/sudoers.d/${USERNAME}
fi

# Copy authorized public keys to directory of this user, if 'yes'
if prompt_yes_no "Copy authorized_keys of root user to directory of '$USERNAME' user? (CAUTION)"; then
    sudo mkdir -p /home/${USERNAME}/.ssh && sudo cp /root/.ssh/authorized_keys /home/${USERNAME}/.ssh/authorized_keys

    # Apply proper permissions and ownership
    sudo chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.ssh
    sudo chmod 700 /home/${USERNAME}/.ssh
    sudo chmod 600 /home/${USERNAME}/.ssh/authorized_keys

    echo "authorized_keys copied to directory of '$USERNAME' user."

    # Restart to apply changes
    sudo service ssh restart
    echo "SSH service restarted and changes applied."
fi


# Print list of all current users
echo "List of all current users:"

awk -F':' '{ if ($3 >= 1000) print $1 }' /etc/passwd