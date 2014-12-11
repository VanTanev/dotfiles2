#!/bin/sh
# Based on http://www.rushis.com/2013/03/consolas-font-on-ubuntu/

set -e
set -x
sudo apt-get install font-manager
sudo apt-get install cabextract
mkdir -p /tmp/consolas
cd /tmp/consolas
wget http://download.microsoft.com/download/E/6/7/E675FFFC-2A6D-4AB0-B3EB-27C9F8C8F696/PowerPointViewer.exe
cabextract -L -F ppviewer.cab PowerPointViewer.exe
cabextract ppviewer.cab
