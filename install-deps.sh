# up to you (me) if you want to run this as a file or copy paste at your leisure
set -e
set -x

WITH_RUBY=${WITH_RUBY:="0"}
RUBY_VERSION=${RUBY_VERSION:="2.2.4"}

if hash apt-get 2>/dev/null; then
    gimme () { sudo apt-get install -y $@; }
    distro="ubuntu"
elif hash yum 2>/dev/null; then
    gimme () { sudo yum install -y $@; }
    distro="centos"
elif hash brew 2>/dev/null; then
    gimme () { brew install -y $@; }
    distro="macos"
else
    echo "Could not determine package manager, exiting"
    exit 1
fi

gimme git

git submodule sync
git submodule update --init --recursive

gimme curl
gimme wget

if [ $distro = ubuntu ]; then
    gimme ack-grep
    gimme xclip
else
    gimme ack
fi

# vim-nox for ruby support
if [ $distro = ubuntu ] && [ "$WITH_RUBY" -ne 0 ]; then
    gimme vim-nox ruby ruby-dev
fi

if [ $distro = ubuntu ]; then
    gimme gawk
fi

# gimme a sane build env on Ubuntu
# https://github.com/sstephenson/ruby-build/wiki#suggested-build-environment
if [ $distro = ubuntu ]; then
    gimme autoconf binutils-doc bison build-essential flex gettext ncurses-dev libssl-dev libyaml-dev libreadline6 libreadline6-dev zlib1g zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev
    # while we're here, let's get some other necessary stuff
    gimme libmysqlclient-dev libsqlite3-dev nodejs nodejs-legacy
    # on Ubuntu we will also want to get the current kernel's headers (Used by virtual machine additions)
    gimme linux-headers-`(uname -r)`
fi
if [ $distro = centos ]; then
    gimme gcc bzip2 openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel
fi

# if we want ruby, execute the following piece of code with sudo
[ "$WITH_RUBY" -ne 0 ] && export RUBY_VERSION && sudo -s <<RUBY_INSTALL
    if [ ! -e /usr/local/bin/ruby-build ]; then
        mkdir -p /usr/src
        cd /usr/src
        git clone https://github.com/sstephenson/ruby-build.git
        cd ruby-build
        ./install.sh
        cd -
    else
        cd /usr/src/ruby-build
        git pull origin master
        ./install.sh
        cd -
    fi

    if [ ! -d /opt/rubies/$RUBY_VERSION ]; then
        mkdir -p /opt/rubies
        /usr/local/bin/ruby-build $RUBY_VERSION /opt/rubies/$RUBY_VERSION
        /opt/rubies/$RUBY_VERSION/bin/gem install bundler
    fi

    if [ ! -e /usr/local/share/chruby/chruby.sh ]; then
        mkdir -p /usr/src
        cd /usr/src
        wget -O chruby-0.3.8.tar.gz https://github.com/postmodern/chruby/archive/v0.3.8.tar.gz
        tar -xzvf chruby-0.3.8.tar.gz
        cd chruby-0.3.8
        make install
        cd -
    fi
RUBY_INSTALL

# https://rvm.io
# rvm for the rubiess
#if ! hash rvm; then
#    curl -L https://get.rvm.io | bash -s stable --ruby
#fi

# https://github.com/jamiew/git-friendly
# the `push` command which copies the github compare URL to my clipboard is heaven
#bash < <( curl https://raw.github.com/jamiew/git-friendly/master/install.sh)

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
if [ $distro = ubuntu ] && [ ! -d ~/code/solarize ]; then
    mkdir -p ~/code/solarize
    cd ~/code/solarize

    wget --no-check-certificate https://raw.github.com/seebi/dircolors-solarized/master/dircolors.ansi-dark
    mv dircolors.ansi-dark ~/.dircolors
    eval `dircolors ~/.dircolors`

    git clone https://github.com/sigurdga/gnome-terminal-colors-solarized.git
    cd gnome-terminal-colors-solarized
    ./set_dark.sh
fi
if [ ! -d ~/.config/base16-shell ]; then
    git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell
fi

# for the c alias (syntax highlighted cat)
gimme python
if [[ $distro =~ ubuntu|centos ]]; then
    gimme python-setuptools
fi

if ! hash pygmentize 2>/dev/null; then
    sudo easy_install Pygments
    sudo easy_install pygments-style-solarized
fi

# setup pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle; \
curl -LSso ~/.vim/autoload/pathogen.vim \
    https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim
