# Dotfiles Repository

This repository contains my personal dotfiles for various tools and configurations, including ZSH, Vim & Neovim, Git, VSCode, and MacOS settings.

It's a minimalist configuration, I don't tinker too much out of the box or use too many plugins, I mainly just want to keep some of my personal set up backed up and ready to deploy.

## Installation

1. **Clone the Repository:**

    ```bash
    git clone --recurse-submodules https://github.com/amitrahman1026/dotfiles.git ~/dotfiles
    ```

2. **Run the Installation Script:**
Navigate to the cloned repository and run the install.sh script. This script will install necessary tools, set up symlinks for the configuration files, and apply other configurations.

    ```bash
    cd ~/dotfiles
    ./install.sh
    ```

3. **MacOS Settings:**
During the installation, you'll be prompted to apply MacOS settings. You can choose to apply them immediately or do it later manually by running:

    ```bash
    source ~/dotfiles/macos/.macos
    ```
## Contents
- zsh/: ZSH configuration files
- vim/: Vim and Neovim configurations
- git/: Git configuration
- vscode/: VSCode settings and extensions list
- macos/: MacOS custom settings script
- brew/: Homebrew dependencies and Brewfile
- iterm2/: iTerm2 configurations and color themes

## Submodules
This repository uses Git submodules to manage certain configurations (e.g., Neovim). To update these submodules, run:

```bash
git submodule update --init --recursive
```

## Future stuff
If this ever gets massive (unlikely because I'd probably not want to automate _everything_) I might want to try out ansible or something similar but I personally hate yaml hell.

## Contributions
Feel free to fork, modify, or contribute to this repository. Any suggestions or improvements are welcome.
