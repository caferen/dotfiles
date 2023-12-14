#!/bin/bash

if mount | grep /home/eren/backup; then
    /usr/bin/rsync -av --delete /home/eren/ssd/drive-cipher /home/eren/backup
    /usr/bin/rsync -av --delete /home/eren/ssd/media-cipher /home/eren/backup
fi

/bin/zsh -i -c "gitcom autosave $HOME"
