# up to you (me) if you want to run this as a file or copy paste at your leisure

if which apt-get > /dev/null; then
   gimme="sudo apt-get install -y"
elif which yum > /dev/null; then
   gimme="sudo yum install -y"
fi

$gimme curl

# https://github.com/jamiew/git-friendly
# the `push` command which copies the github compare URL to my clipboard is heaven
bash < <( curl https://raw.github.com/jamiew/git-friendly/master/install.sh)

# https://rvm.io
# rvm for the rubiess
curl -L https://get.rvm.io | bash -s stable --ruby

# https://github.com/rupa/z
# z, oh how i love you
cd ~/code
git clone https://github.com/rupa/z.git
chmod +x ~/code/z/z.sh
# also consider moving over your current .z file if possible. it's painful to rebuild :)

# z binary is already referenced from .bash_profile

$gimme python python-setuptools

# for the c alias (syntax highlighted cat)
sudo easy_install Pygments

