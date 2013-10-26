# some more ls aliases
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias lla='ls -lA'
alias l='ls -CF'
# easy stuff
alias gi='git'
alias ack="ack-grep"
alias g='git'
alias tu='tar zxvf'
alias v='vim --remote-silent'
alias rb='ruby'
alias r='rails'

# irb is broken under win without this
if [[ `uname` == MINGW32* ]]; then
    alias irb='irb --noreadline'
fi

if [[ `uname -a` == *Ubuntu* ]]; then
    alias gimme='sudo apt-get install -y'
fi
