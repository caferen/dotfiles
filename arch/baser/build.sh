#!/bin/sh

makepkg -sf || exit 1

mv baser-git-1-any.pkg.tar.zst baser.pkg.tar.zst

git -C $HOME add -A
git -C $HOME commit -m baser
git -C $HOME push
