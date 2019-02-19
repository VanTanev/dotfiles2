#!/usr/bin/env bash
# Based on http://www.rushis.com/2013/03/consolas-font-on-ubuntu/

set -eu -o pipefail
set -x

sudo apt-get install font-manager
sudo apt-get install cabextract
mkdir -p /tmp/consolas
cd /tmp/consolas
if [ ! -f /tmp/consolas/PowerPointViewer.exe ]; then
    wget https://sourceforge.net/projects/mscorefonts2/files/cabs/PowerPointViewer.exe/download -O PowerPointViewer.exe
fi
cabextract -L -F ppviewer.cab PowerPointViewer.exe
cabextract ppviewer.cab
xdg-open /tmp/consolas
