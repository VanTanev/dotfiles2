#!/usr/bin/env bash

set -o nounset    # error when referencing undefined variable
set -o errexit    # exit when command fails

# Use package feature to install coc.nvim
rm -rf /tmp/coc.nvim
git clone https://github.com/neoclide/coc.nvim.git --depth=1 /tmp/coc.nvim
# If you want to use plugin manager, change DIR to plugin directory used by that manager.
# DIR_NEOVIM=~/.local/share/nvim/site/pack/coc/start
# For vim user, the directory is different
DIR_VIM=~/.vim/pack/coc/start
DIRS=($DIR_VIM)
for DIR in "${DIRS[@]}"
do
    mkdir -p $DIR
    cp -rf /tmp/coc.nvim $DIR
done
rm -rf /tmp/coc.nvim
for DIR in "${DIRS[@]}"
do
    cd $DIR/coc.nvim && ./install.sh nightly
done

# Install extensions
mkdir -p ~/.config/coc/extensions
cd ~/.config/coc/extensions
if [ ! -f package.json ]
then
  echo '{"dependencies":{}}'> package.json
fi
# Change arguments to the extensions you need
yarn add coc-tsserver
