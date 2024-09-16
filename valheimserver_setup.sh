#!/usr/bin/env bash
cd /root
set -ex
useradd -m steam || true
ln -snf /home/steam steam
apt update -y
apt upgrade -y
apt install software-properties-common -y
dpkg --add-architecture i386
apt-add-repository multiverse -y
apt update -y
apt install steamcmd -y

sudo -iu steam bash <<'EOF'
cd ~
set -ex
/usr/games/steamcmd +@sSteamCmdForcePlatformType linux +force_install_dir "$HOME/valheimserver" +login anonymous +app_update 896660 +quit
mkdir -p "$HOME/valheimserver/valheim_save_data"
echo 76561197994236995 > "$HOME/valheimserver/valheim_save_data/adminlist.txt"
EOF

#ln -s valheimserver.service /etc/systemd/system/valheimserver.service
systemctl link "$HOME/valheimserver.service"
