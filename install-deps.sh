# up to you (me) if you want to run this as a file or copy paste at your leisure
set -e
set -x

git submodule init
git submodule update

if hash apt-get 2>/dev/null; then
    gimme="sudo apt-get install -y"
elif hash yum 2>/dev/null; then
    gimme="sudo yum install -y"
elif hash brew 2>/dev/null; then
    gimme="brew install"
else
    echo "Could not determine package manager, exiting"
    exit 1
fi

$gimme curl
$gimme wget
if [[ `uname -a` == *Ubuntu* ]]; then
    $gimme ack-grep
else
    $gimme ack
fi

# required stuff for Commant-T vim
if [[ `uname -a` == *Ubuntu* ]]; then
    $gimme vim-nox ruby ruby-dev
    cd .vim/bundle/Command-T/
    /usr/bin/rake1.9.1 make
fi

# https://fixubuntu.com/
if [[ `uname -a` == *Ubuntu* ]]; then
    V=`/usr/bin/lsb_release -rs`; if [ $V \< 12.10 ]; then echo "Good news! Your version of Ubuntu doesn't invade your privacy."; else gsettings set com.canonical.Unity.Lenses remote-content-search none; if [ $V \< 13.10 ]; then sudo apt-get remove -y unity-lens-shopping; else gsettings set com.canonical.Unity.Lenses disabled-scopes "['more_suggestions-amazon.scope', 'more_suggestions-u1ms.scope', 'more_suggestions-populartracks.scope', 'music-musicstore.scope', 'more_suggestions-ebay.scope', 'more_suggestions-ubuntushop.scope', 'more_suggestions-skimlinks.scope']"; fi; if ! grep -q productsearch.ubuntu.com /etc/hosts; then echo -e "\n127.0.0.1 productsearch.ubuntu.com" | sudo tee -a /etc/hosts >/dev/null; fi; echo "All done. Enjoy your privacy."; fi
fi

# gimme a sane build env on Ubuntu
# https://github.com/sstephenson/ruby-build/wiki#suggested-build-environment
if [[ `uname -a` == *Ubuntu* ]]; then
    $gimme autoconf bison build-essential libssl-dev libyaml-dev libreadline6 libreadline6-dev zlib1g zlib1g-dev
    # while we're here, let's get some other necessary stuff
    $gimme libmysqlclient-dev libsqlite3-dev nodejs
fi

export RUBY_VERSION="2.0.0-p451"
sudo -s <<RUBY_INSTALL
    if [ ! -e /usr/local/bin/ruby-build ]; then
    mkdir -p /usr/src
        cd /usr/src
        git clone https://github.com/sstephenson/ruby-build.git
        cd ruby-build
        ./install.sh
        cd -
    fi

    if [ ! -d /opt/rubies/$RUBY_VERSION ]; then
        mkdir -p /opt/rubies
        ruby-build $RUBY_VERSION /opt/rubies/$RUBY_VERSION
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
if [[ `uname -a` == *Ubuntu* ]] && [ ! -d ~/code/solarize ]; then
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
$gimme python
if [[ `uname -a` == *Ubuntu* ]]; then
    $gimme python-setuptools
fi

if ! hash pygmentize 2>/dev/null;then
    sudo easy_install Pygments
    sudo easy_install pygments-style-solarized
fi

# setup pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle; \
curl -LSso ~/.vim/autoload/pathogen.vim \
    https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim
