#!/usr/bin/env bash
set -e

DEST='/mnt/nfs/backup'
SYNC='/var/lib/docker/volumes'

ARCHIVE="backup-$(hostname)-docker-$(date +'%F').tar.gz"

if [[ ! -d $DEST ]]; then
  mkdir -p $DEST
fi

# To mount a remote NFS directory:
#mount -t nfs <host>:<remote-dir> <local-dir>
mount -t nfs 0.0.0.0:/backup "$DEST"
#rsync -auzr $DEST $SYNC

# stop running containers
mapfile -t running_containers < <(docker ps -q)
if ((${#running_containers[@]})); then
  docker stop "${running_containers[@]}"
fi

#Backup archive
tar --warning=no-file-changed -cpzf "$DEST/$ARCHIVE" "$SYNC"

# start containers
mapfile -t all_containers < <(docker ps -a -q)
if ((${#all_containers[@]})); then
  docker start "${all_containers[@]}"
fi

#Delete old files
#find $DEST -mtime +14 -delete

echo "finished backup"
