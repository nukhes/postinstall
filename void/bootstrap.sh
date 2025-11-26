#!/usr/bin/env bash
set -euo pipefail

# Detect the real user
REAL_USER="${SUDO_USER:-$USER}"
USER_HOME=$(eval echo "~$REAL_USER")
EMAIL="79018158+nukhes@users.noreply.github.com"
REPO="https://github.com/nukhes/postinstall.git"
WORKDIR="$USER_HOME/postinstall/void"

echo "[*] Installing base packages (ansible + multilib/nonfree repos) as root..."
sudo xbps-install -Sy ansible void-repo-multilib void-repo-nonfree

echo "[*] Updating system as root..."
sudo xbps-install -Su

# SSH key generation (in user's home)
if [ ! -f "$USER_HOME/.ssh/id_ed25519" ]; then
    echo "[*] Generating SSH key for $REAL_USER..."
    sudo -u "$REAL_USER" ssh-keygen -t ed25519 -C "$EMAIL" -f "$USER_HOME/.ssh/id_ed25519" -N ""
    echo "[*] Public key for $REAL_USER:"
    cat "$USER_HOME/.ssh/id_ed25519.pub"
    echo ">>> Add this key to your GitHub account (Settings → SSH and GPG keys)."
    read -p "Press Enter to proceed..."
fi

# Clone repo if it doesn't exist
if [ ! -d "$WORKDIR" ]; then
    echo "[*] Cloning repository for $REAL_USER..."
    sudo -u "$REAL_USER" git clone "$REPO" "$USER_HOME/postinstall"
fi

cd "$WORKDIR"

echo "[*] Running playbook as $REAL_USER..."
ansible-playbook -i inventory.ini site.yml -K