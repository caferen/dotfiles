#!/bin/bash

if mount | grep /home/eren/backup; then
    /usr/bin/rsync -av --delete /home/eren/ssd/drive-cipher /home/eren/backup
    /usr/bin/rsync -av --delete /home/eren/ssd/media-cipher /home/eren/backup
    /usr/bin/rsync -av --delete /home/eren/ssd/images /home/eren/backup
else
    exit 1
fi
