#!/usr/bin/env bash

immich-go -server=http://SERVER_IP:PORT \
  -key=AUe0TZFraaz7vMcivoFp8IVzhlMR99RtDDVwLtAWA7A \
  upload -dry-run -create-albums -google-photos takeout-*.zip

