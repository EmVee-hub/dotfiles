# dotfiles

This repository manages shell settings, user commands, and the Neovim
configuration. Neovim is tracked as the `nvim-conf` submodule and `setup.sh`
links its `init.lua` and `lua/` files into `~/.config/nvim`.

`setup.sh` installs the pinned `yaml-language-server` npm package without
Docker and links it into `~/.local/bin`.

`setup.sh` includes `gitconfig` from the user's global Git configuration,
preserving other user-specific Git settings while managing the shared defaults.

`setup.sh` links the tmux configuration to `~/.tmux.conf`. It enables tmux
clipboard integration so terminal applications such as GitHub Copilot CLI can
copy through OSC 52 to the terminal clipboard without mounting Windows drives.
