#!/bin/sh

makepkg -sf || exit 1

mv baser-git-1-any.pkg.tar.zst baser.pkg.tar.zst

git -C $HOME/.dotfiles add -A
git -C $HOME/.dotfiles commit -m baser
git -C $HOME/.dotfiles push
