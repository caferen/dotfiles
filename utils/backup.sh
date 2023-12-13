#!/bin/bash

mount /home/eren/backup
if mount | grep /home/eren/backup; then
    /usr/bin/rsync -a --delete /home/eren/ssd/drive-cipher /home/eren/backup
    /usr/bin/rsync -a --delete /home/eren/ssd/media-cipher /home/eren/backup
    umount /home/eren/backup
else
    exit 1
fi
