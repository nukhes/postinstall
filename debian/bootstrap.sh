#!/usr/bin/env bash
set -euo pipefail

# Detect the real user
REAL_USER="${SUDO_USER:-$USER}"
USER_HOME=$(eval echo "~$REAL_USER")
EMAIL="79018158+nukhes@users.noreply.github.com"
REPO="https://github.com/nukhes/dotfiles.git"
DOTSDIR="$USER_HOME/.dots"

echo "[*] Updating system as root..."
sudo apt update -y && sudo apt upgrade -y
echo "[*] Installing base packages as root..."
sudo apt install -y git curl wget stow python3 python3-pip 
echo "[*] Installing pixi and some global packages as $REAL_USER..."
curl -fsSL https://pixi.sh/install.sh | sh
pixi global install eza nodejs pnpm

echo "[*] Installing fish shell as root..."
echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/4/Debian_13/ /' | sudo tee /etc/apt/sources.list.d/shells:fish:release:4.list
curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:4/Debian_13/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_fish_release_4.gpg > /dev/null
sudo apt update
sudo apt install fish

echo "[*] Setting up SSH for $REAL_USER..."
if [ ! -f "$USER_HOME/.ssh/id_ed25519" ]; then
    echo "[*] Generating SSH key for $REAL_USER..."
    sudo -u "$REAL_USER" ssh-keygen -t ed25519 -C "$EMAIL" -f "$USER_HOME/.ssh/id_ed25519" -N ""
    echo "[*] Public key for $REAL_USER:"
    cat "$USER_HOME/.ssh/id_ed25519.pub"
    echo ">>> Add this key to your GitHub account (Settings → SSH and GPG keys)."
    read -p "Press Enter to proceed..."
fi

# Clone dotfiles
if [ ! -d "$DOTSDIR" ]; then
    echo "[*] Cloning dots for $REAL_USER..."
    sudo -u "$REAL_USER" git clone "$REPO" "$USER_HOME/.dots"
fi

cd "$DOTSDIR"
stow --target="$USER_HOME" --restow *
