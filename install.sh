#!/bin/bash
# Set up a new machine from this repo. Clone the repo to ~/dotfiles first:
#   git clone git@github.com:amitrahman1026/dotfiles.git ~/dotfiles && ~/dotfiles/install.sh
set -euo pipefail

if ! command -v chezmoi >/dev/null; then
  case "$(uname -s)" in
    Darwin)
      command -v brew >/dev/null || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      eval "$(/opt/homebrew/bin/brew shellenv)"
      brew install chezmoi ;;
    Linux)
      if command -v pacman >/dev/null; then sudo pacman -S --needed --noconfirm chezmoi
      elif command -v apt-get >/dev/null; then sudo apt-get install -y chezmoi
      else echo "install chezmoi first: https://www.chezmoi.io/install/" >&2; exit 1
      fi ;;
  esac
fi

chezmoi init --source "$HOME/dotfiles"
chezmoi diff
read -r -p "Apply these changes? [y/N] " reply
[[ $reply =~ ^[Yy]$ ]] && chezmoi apply
