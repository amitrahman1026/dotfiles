#!/bin/bash
# Set up a new machine from this repo. Needs no admin rights. Clone the repo to ~/dotfiles first:
#   git clone https://github.com/amitrahman1026/dotfiles.git ~/dotfiles && ~/dotfiles/install.sh
set -euo pipefail

if ! command -v chezmoi >/dev/null; then
  if command -v brew >/dev/null; then
    brew install chezmoi
  else
    # Official installer; puts a single binary in ~/.local/bin.
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
    export PATH="$HOME/.local/bin:$PATH"
  fi
fi

# Asks for the machine profile (personal or work) and git email once.
chezmoi init --source "$HOME/dotfiles"

# Personal machines: decrypt the age key first, so chezmoi diff can read the secrets.
chezmoi execute-template < "$HOME/dotfiles/home/run_onchange_before_00-age-key.sh.tmpl" | bash

chezmoi diff
read -r -p "Apply these changes? [y/N] " reply
[[ $reply =~ ^[Yy]$ ]] && chezmoi apply
