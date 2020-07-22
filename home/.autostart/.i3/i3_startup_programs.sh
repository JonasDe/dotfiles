#!/bin/bash
exec i3-msg 'workspace 2; exec google-chrome-stable; exec station.AppImage; workspace 1; exec gnome-terminal; workspace 3; exec pycharm.sh; workspace 3'
