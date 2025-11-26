# postinstall
Setup Linux for my use-case.

## Void Linux
```bash
sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/nukhes/postinstall/refs/heads/main/void/bootstrap.sh)"
```

## Debian (Server Setup)
Promote your user to sudoers.
```bash
su -
usermod -aG sudo USERNAME
newgrp sudo
```

Run bootstrap.sh
```bash
sudo apt install -y sudo curl
sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/nukhes/postinstall/refs/heads/main/debian/bootstrap.sh)"
```
