#!/usr/bin/env bash
set -e

DEST='/mnt/nfs/backup'
SYNC='/home/user'

ARCHIVE="backup-home-$(hostname)-$(date +'%F').tar.gz"
CMD='tar -cpzf'

if [[ ! -d $DEST ]];
then
    mkdir -p $DEST
fi

server=nfs-server.local
share=/path/to/nfs/share

NFS="mount -t nfs $server:$share $DEST"

$NFS

#rsync -auzr $DEST $SYNC

#Backup to archive
$CMD $DEST/$ARCHIVE $SYNC

#Delete old files
#find $DEST -mtime +14 -delete

umount $DEST
