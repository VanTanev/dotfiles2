#!/usr/bin/env bash
set -euo pipefail

sudo apt update
sudo apt install -y \
    vim \
    gnome-tweak-tool \
    shellcheck \
    curl \
    zsh \
    ruby
git submodule sync
git submodule update --init --recursive

# https://github.com/rupa/z
# z, oh how i love you
if [ ! -d ~/code/z ]; then
    mkdir -p ~/code
    cd ~/code
    git clone https://github.com/rupa/z.git
    chmod +x ~/code/z/z.sh
    # also consider moving over your current .z file if possible. it's painful to rebuild :)
    # z binary is already referenced from .bash_profile
fi

# coc.nvim
if [ ! -d ~/.vim/pack/coc/start ]; then
    mkdir -p ~/.vim/pack/coc/start
    cd ~/.vim/pack/coc/start
    git clone --branch release https://github.com/neoclide/coc.nvim.git --depth=1
fi

if ! command -v docker; then
    sudo apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        lsb-release
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
        | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo \
        "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    sudo usermod -aG docker "$USER"
    docker --version
fi

if ! command -v docker-compose; then
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo curl \
        -L https://raw.githubusercontent.com/docker/compose/1.29.2/contrib/completion/bash/docker-compose \
        -o /etc/bash_completion.d/docker-compose
    docker-compose --version
fi

if [ "/bin/bash" = "$SHELL" ]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

# setup pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle; \
curl -LSso ~/.vim/autoload/pathogen.vim \
    https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim
