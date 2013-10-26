# up to you (me) if you want to run this as a file or copy paste at your leisure

if hash apt-get 2>/dev/null; then
   gimme="sudo apt-get install -y"
elif hash yum > /dev/null; then
   gimme="sudo yum install -y"
fi

$gimme curl
$gimme ack-grep

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
mkdir -p ~/code
cd ~/code
git clone https://github.com/rupa/z.git
chmod +x ~/code/z/z.sh
# also consider moving over your current .z file if possible. it's painful to rebuild :)

# z binary is already referenced from .bash_profile

# for the c alias (syntax highlighted cat)
$gimme python python-setuptools
sudo easy_install Pygments

# setup pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle; \
curl -Sso ~/.vim/autoload/pathogen.vim \
    https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim
