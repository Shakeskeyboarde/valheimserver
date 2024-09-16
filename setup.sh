#!/usr/bin/env bash
cd "$(dirname "$0")"
set -ex
useradd -m steam || true
ln -snf /home/steam "$HOME/steam"
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
if [ ! -d "$HOME/valheimserver/valheim_save_data" ]; then 
  mkdir -p "$HOME/valheimserver/valheim_save_data"
  echo 76561197994236995 > "$HOME/valheimserver/valheim_save_data/adminlist.txt"
  echo 76561197994236995 > "$HOME/valheimserver/valheim_save_data/permittedlist.txt"
fi
EOF

#ln -s valheimserver.service /etc/systemd/system/valheimserver.service
systemctl link ./valheimserver.service

set +x
echo
echo "TODO:"
echo "  - Restart (system): shutdown -r now"
echo "  - Service (systemd): systemctl enable valheimserver"
echo "  - Backups (cron): 0 9 * * * \"$CWD/valheimserver_backup.sh\" > /var/log/valheimserver_backup_cron.log 2>&1"
echo

