#!/usr/bin/env bash
shopt -s extglob
SERVICE=valheimserver
TODAY="$(date +'%Y%m%d%H%M%S')"

if ! systemctl is-active --quiet valheimserver; then
  echo "$SERVICE not running"
  exit 0;
fi

cd "/home/steam/$SERVICE/valheim_save_data/worlds_local"

set -ex
systemctl stop "$SERVICE"
sleep 20
mkdir -p "/root/backups/$SERVICE"
find "/root/backups/$SERVICE" -iname '*.tgz' -mtime '+30' -exec rm -rf {} \;
tar zcf "/root/backups/$SERVICE/$TODAY.tgz" !(*_backup_auto-*|*.old.*).@(db|fwl)
systemctl start "$SERVICE"

