#!/usr/bin/env bash
set -euo pipefail

sudo apt update
sudo apt install -y \
    vim \
    gnome-tweak-tool \
    shellcheck \
    curl \
    zsh \
    ruby \
    wget \
    tree \
    htop \
    silversearcher-ag \
    python3-pip \
    jq

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

if ! command -v fd > /dev/null; then
    sudo apt install -y fd-find
    ln -s $(which fdfind) ~/.local/bin/fd
fi

if ! command -v aws > /dev/null; then
    pip3 install awscli --upgrade --user
fi
# coc.nvim
if [ ! -d ~/.vim/pack/coc/start ]; then
    mkdir -p ~/.vim/pack/coc/start
    cd ~/.vim/pack/coc/start
    git clone --branch release https://github.com/neoclide/coc.nvim.git --depth=1
fi

if ! command -v docker > /dev/null; then
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

if ! command -v docker-compose > /dev/null; then
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

export NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
    # shellcheck source=/dev/null
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    echo 'Node version to install:'
    read -r NODE_VERSION_TO_INSTALL
    nvm install "$NODE_VERSION_TO_INSTALL"
    npm i -g yarn
fi

if ! command -v hyperfine > /dev/null; then
    wget https://github.com/sharkdp/hyperfine/releases/download/v1.11.0/hyperfine_1.11.0_amd64.deb -P /tmp
    sudo dpkg -i /tmp/hyperfine_1.11.0_amd64.deb
fi

# setup pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle; \
curl -LSso ~/.vim/autoload/pathogen.vim \
    https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim

echo 'SUCCESS!'
