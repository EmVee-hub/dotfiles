#!/bin/bash
# setup.sh

DOTFILES_DIR="$(cd "$(dirname "$(realpath "$0")")" && pwd)"
BIN_DIR="$DOTFILES_DIR/bin"

chsh -s $(which zsh)

find "$DOTFILES_DIR/shell" -maxdepth 1 -type f | while read -r source; do
    filename="${source##*/}"
    target="$HOME/.$filename"

    echo "Creating symlink: $target -> $source"
    ln -sfn "$source" "$target"
    chmod +x "$source"
done

find "$DOTFILES_DIR/bin" -maxdepth 1 -type f | while read -r source; do
    filename="${source##*/}"
    target="$HOME/.local/bin/$filename"

    echo "Creating symlink: $target -> $source"
    ln -sfn "$source" "$target"
    chmod +x "$source"
done
