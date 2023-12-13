#!/bin/bash

mount /home/eren/backup
/usr/bin/rsync -a --delete /home/eren/ssd/drive-cipher/ /home/eren/backup
/usr/bin/rsync -a --delete /home/eren/ssd/media-cipher/ /home/eren/backup
umount /home/eren/backup
