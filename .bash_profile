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
