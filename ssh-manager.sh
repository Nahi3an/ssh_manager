#!/bin/bash


read -p "Enter your email address: " email
read -p "Enter the new SSH key filename (e.g., id_ed25519_bitbucket_work): " key_name
read -p "Enter the Host alias (e.g., bitbucket-work): " host_alias
read -p "Enter the real HostName (e.g., bitbucket.org or github.com): " real_hostname

key_path="$HOME/.ssh/$key_name"
config_file="$HOME/.ssh/config"


mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"


echo -e "\n[1/3] Generating SSH key..."
ssh-keygen -t ed25519 -C "$email" -f "$key_path"


touch "$config_file"
chmod 600 "$config_file"


echo -e "\n[2/3] Updating SSH config..."
cat <<EOF >> "$config_file"

# Added by ssh-manager for $email
Host $host_alias
    HostName $real_hostname
    User git
    IdentityFile $key_path
EOF


echo -e "\n[3/3] Setup Complete!"
echo "======================================================="
echo "Copy the public key below and add it to your provider:"
echo "======================================================="
cat "${key_path}.pub"
echo "======================================================="
echo "Once added, test the connection by running:"
echo "ssh -T git@$host_alias"