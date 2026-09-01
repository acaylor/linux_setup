#!/usr/bin/env bash
set -e

DEST='/mnt/nfs/backup'
SYNC='/home/user'

ARCHIVE="backup-home-$(hostname)-$(date +'%F').tar.gz"

if [[ ! -d $DEST ]]; then
  mkdir -p $DEST
fi

server=nfs-server.local
share=/path/to/nfs/share

mount -t nfs "$server:$share" "$DEST"

#rsync -auzr $DEST $SYNC

#Backup to archive
tar -cpzf "$DEST/$ARCHIVE" "$SYNC"

#Delete old files
#find $DEST -mtime +14 -delete

umount "$DEST"
