# dotfiles

This repository manages shell settings, user commands, and the Neovim
configuration. Neovim is tracked as the `nvim-conf` submodule and `setup.sh`
links its `init.lua` and `lua/` files into `~/.config/nvim`.

`setup.sh` includes `gitconfig` from the user's global Git configuration,
preserving other user-specific Git settings while managing the shared defaults.
