# up to you (me) if you want to run this as a file or copy paste at your leisure
set -e

git submodule init
git submodule update

if hash apt-get 2>/dev/null; then
    gimme="sudo apt-get install -y"
elif hash yum > /dev/null; then
    gimme="sudo yum install -y"
else
    echo "Could not determine package manager, exiting"
    exit 1
fi

$gimme curl
$gimme ack-grep

# required stuff for Commant-T vim
if [[ `uname -a` == *Ubuntu* ]]; then
    $gimme vim-nox ruby ruby-dev
    cd .vim/bundle/Command-T/
    /usr/bin/rake1.9.1 make
fi

# https://github.com/jamiew/git-friendly
# the `push` command which copies the github compare URL to my clipboard is heaven
#bash < <( curl https://raw.github.com/jamiew/git-friendly/master/install.sh)

# https://rvm.io
# rvm for the rubiess
if ! hash rvm; then
    curl -L https://get.rvm.io | bash -s stable --ruby
fi

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

# setup solarized
if [ ! -d ~/code/solarize ]; then
    mkdir -p ~/code/solarize
    cd ~/code/solarize

    wget --no-check-certificate https://raw.github.com/seebi/dircolors-solarized/master/dircolors.ansi-dark
    mv dircolors.ansi-dark ~/.dircolors
    eval `dircolors ~/.dircolors`

    git clone https://github.com/sigurdga/gnome-terminal-colors-solarized.git
    cd gnome-terminal-colors-solarized
    ./set_dark.sh
fi

# for the c alias (syntax highlighted cat)
$gimme python python-setuptools
sudo easy_install Pygments
sudo easy_install pygments-style-solarized

# setup pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle; \
curl -Sso ~/.vim/autoload/pathogen.vim \
    https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim
