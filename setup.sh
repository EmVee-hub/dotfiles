#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd -- "$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")" && pwd)"
ZSH_PATH="$(command -v zsh)"
current_shell="$(getent passwd "${USER:-$(id -un)}" | cut -d: -f7)"

if [[ "$current_shell" != "$ZSH_PATH" ]]; then
    chsh -s "$ZSH_PATH"
fi

mkdir -p "$HOME/.local/bin"
while IFS= read -r -d '' source; do
    filename="${source##*/}"
    target="$HOME/.$filename"

    printf 'Creating symlink: %s -> %s\n' "$target" "$source"
    ln -sfn "$source" "$target"
done < <(find "$DOTFILES_DIR/shell" -maxdepth 1 -type f -print0)

if ! git config --global --get-all include.path 2>/dev/null \
    | grep -Fqx "$DOTFILES_DIR/gitconfig"; then
    git config --global --add include.path "$DOTFILES_DIR/gitconfig"
fi

while IFS= read -r -d '' source; do
    filename="${source##*/}"
    target="$HOME/.local/bin/$filename"

    printf 'Creating symlink: %s -> %s\n' "$target" "$source"
    ln -sfn "$source" "$target"
done < <(find "$DOTFILES_DIR/bin" -maxdepth 1 -type f -print0)

NVIM_DIR="$DOTFILES_DIR/nvim-conf"
if [[ ! -d "$NVIM_DIR/lua" || ! -f "$NVIM_DIR/init.lua" ]]; then
    printf 'Neovim config submodule is missing: %s (run git submodule update --init --recursive).\n' \
        "$NVIM_DIR" >&2
    exit 1
fi

while IFS= read -r -d '' source; do
    relative="${source#"$NVIM_DIR"/}"
    target="$HOME/.config/nvim/$relative"

    mkdir -p "$(dirname "$target")"
    printf 'Creating symlink: %s -> %s\n' "$target" "$source"
    ln -sfn "$source" "$target"
done < <(find "$NVIM_DIR" -type f \( -path "$NVIM_DIR/init.lua" -o -path "$NVIM_DIR/lua/*" \) -print0)

if [[ -f "$DOTFILES_DIR/config/minikube/driver" ]]; then
    if ! command -v minikube >/dev/null 2>&1; then
        printf 'minikube is configured in dotfiles but is not installed.\n' >&2
        exit 1
    fi
    minikube config set driver "$(<"$DOTFILES_DIR/config/minikube/driver")"
fi
