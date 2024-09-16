#!/usr/bin/env bash
shopt -s extglob
SERVICE=valheimserver
TODAY="$(date +'%Y%m%d%H%M%S')"
SOURCE_ROOT="/home/steam/$SERVICE"
TARGET_ROOT="/root/backups/$SERVICE"

if ! systemctl is-active --quiet valheimserver; then
  echo "$SERVICE not running"
  exit 0;
fi

cd "$SOURCE_ROOT/valheim_save_data/worlds_local"

set -ex
systemctl stop "$SERVICE"
sleep 20
mkdir -p "$TARGET_ROOT"
find "$TARGET_ROOT" -iname '*.tgz' -mtime '+30' -exec rm -rf {} \;
tar zcf "$TARGET_ROOT/$TODAY.tgz" !(*_backup_auto-*|*.old.*).@(db|fwl)
systemctl start "$SERVICE"

