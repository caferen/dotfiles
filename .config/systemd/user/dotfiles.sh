#!/bin/sh

dconf dump / > $HOME/.config/dconf/dconf-settings.ini && \
git add -A && \
git commit -m autosave && \
git push
