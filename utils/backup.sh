#!/bin/bash

if mount | grep /home/eren/backup; then
    /usr/bin/rsync -av --delete /home/eren/ssd/drive-cipher /home/eren/backup
    /usr/bin/rsync -av --delete /home/eren/ssd/media-cipher /home/eren/backup
    /usr/bin/rsync -av --delete /home/eren/ssd/mail-cipher /home/eren/backup
    /usr/bin/rsync -av --delete /home/eren/ssd/takeout-cipher /home/eren/backup
    /usr/bin/rsync -av --delete /home/eren/ssd/wallpapers /home/eren/backup
fi
