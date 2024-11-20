#!/bin/bash

echo "This is a WIP...dont use it!"
exit 1

# Requesting sudo upfront
echo "Requesting administrative access..."
sudo -v

# Keep-alive: update existing `sudo` time stamp until this script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Xcode Command Line Tools
echo "Installing Xcode Command Line Tools..."
xcode-select --install

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Update Homebrew recipes
echo "Updating Homebrew..."
brew update

# Install all our dependencies with bundle (See Brewfile)
echo "Installing Homebrew bundle..."
brew tap homebrew/bundle
brew bundle --file=~/dotfiles/brew/Brewfile

# Make ZSH the default shell environment
echo "Setting ZSH as the default shell..."
chsh -s $(which zsh)

# Install Oh My Zsh
echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Initialize and update submodules
echo "Initializing and updating submodules..."
git submodule update --init --recursive

# Symlink configurations
echo "Creating symlinks for configuration files..."
ln -sf ~/dotfiles/git/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/vim/.vimrc ~/.vimrc
ln -sf ~/dotfiles/vim/nvim ~/.config/nvim
ln -sf ~/dotfiles/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc

# Install VSCode extensions
echo "Installing VSCode extensions..."
cat ~/dotfiles/vscode/vscode_extensions.txt | xargs -L 1 code --install-extension

# Ask for MacOS settings installation
read -p "Do you want to apply MacOS settings now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Applying MacOS settings..."
    source ~/dotfiles/macos/.macos
else
    echo "MacOS settings were not applied. You can apply them later by running: source ~/dotfiles/macos/.macos"
fi

echo "Installation complete! Please restart your computer for all changes to take effect. Also remember to check if themes and fonts didn't break lmao"

