#!/usr/bin/env bash
set -e

DEST='/mnt/nfs/backup'
SYNC='/var/lib/docker/volumes'

ARCHIVE="backup-$(hostname)-docker-$(date +'%F').tar.gz"
CMD='tar --warning=no-file-changed -cpzf'

if [[ ! -d $DEST ]];
then
    mkdir -p $DEST
fi

# To mount a remote NFS directory:
#mount -t nfs <host>:<remote-dir> <local-dir>
NFS="mount -t nfs 0.0.0.0:/backup $DEST"

$NFS
#rsync -auzr $DEST $SYNC

# stop running containers
docker stop $(docker ps -q)

#Backup archive
$CMD $DEST/$ARCHIVE $SYNC

# start containers
docker start $(docker ps -a -q)

#Delete old files
#find $DEST -mtime +14 -delete

echo "finished backup"
