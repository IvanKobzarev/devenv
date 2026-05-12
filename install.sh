#!/bin/bash
# Symlink dotfiles into $HOME. Run from the devenv repo root.
# Existing files are backed up to *.bak.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  local src="$SCRIPT_DIR/$1"
  local dst="$HOME/$2"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    echo "  backup: $dst -> ${dst}.bak"
    mv "$dst" "${dst}.bak"
  fi
  ln -sfn "$src" "$dst"
  echo "  linked: $dst -> $src"
}

echo "=== Linking dotfiles ==="
link .vimrc .vimrc
link .tmux.conf .tmux.conf
link .gitconfig .gitconfig
link .inputrc .inputrc
link .bash_profile .bash_profile

echo ""
echo "=== Linking nvim config ==="
mkdir -p "$HOME/.config"
link nvim .config/nvim

echo ""
echo "=== Installing Vundle (vim) ==="
if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]; then
  git clone https://github.com/VundleVim/Vundle.vim.git "$HOME/.vim/bundle/Vundle.vim"
  echo "  Run :PluginInstall inside vim to finish."
else
  echo "  Vundle already installed."
fi

echo ""
echo "Done. Restart your shell or run: source ~/.bash_profile"
