#!/usr/bin/env bash
set -e
systemctl start --no-block valheimserver
journalctl -fu valheimserver

