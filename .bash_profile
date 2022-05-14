# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin

shopt -s checkwinsize

export PATH
unset USERNAME

export EDITOR=vim

git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

export PS1=' \w\[\033[0;32m\] $(git branch 2>/dev/null | grep "^*" | colrm 1 2)\[\033[0;32m\]\n└─\[\033[0m\033[0;32m\] \$\[\033[0m\033[0;32m\]\[\033[0m\] '

function cls {
  clear && printf '\e[3J'
}

export DISPLAY=:0

function ctagsup() {
  ctags -R --c++-kinds=+p --fields=+iaS --extra=+q --language-force=C++ --exclude=.git --exclude=build_android* --links=no
}

CLUSTER_SSH_HOST="cluster_host"

function sshcluster {
  ssh -t $CLUSTER_SSH_HOST "tmux attach || tmux new"
}


DEVSERVER="devserver"
function adb_tunnel_client_part {
  ssh $DEVSERVER -L 40020:localhost:4000 -R 15037:localhost:5037 -R 2828:localhost:2828 -R 2829:localhost:2829 -R 2830:localhost:2830 -R 2831:localhost:2831 -R 2832:localhost:2832 -R 5039:localhost:5039
}


function rsyncdev {
  rsync -avz $DEVSERVER:/home/ivankobzarev/rsync ~
}
