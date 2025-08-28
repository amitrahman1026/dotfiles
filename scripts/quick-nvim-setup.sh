#!/bin/bash

set -euo pipefail

# Quick nvim setup script for servers
# This is for when you just need nvim config without full dotfiles

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() {
    echo -e "${BLUE}[$(date +'%H:%M:%S')]${NC} $1"
}

success() {
    echo -e "${GREEN}✓${NC} $1"
}

error() {
    echo -e "${RED}✗${NC} $1"
}

# Configuration
NVIM_REPO_URL="https://github.com/amitrahman1026/nvim-config.git"
BRANCH=${1:-"sandbox-server"}
CONFIG_DIR="$HOME/.config/nvim"

# Usage
usage() {
    echo "Usage: $0 [branch]"
    echo "Quick nvim config setup for servers"
    echo ""
    echo "Arguments:"
    echo "  branch    Git branch to use (default: sandbox-server)"
    echo ""
    echo "Examples:"
    echo "  curl -sSL https://raw.githubusercontent.com/amitrahman1026/dotfiles/main/scripts/quick-nvim-setup.sh | bash"
    echo "  $0 sandbox-server"
}

install_nvim_config() {
    log "Setting up nvim config for server environment..."
    log "Branch: $BRANCH"
    
    # Check if nvim is installed
    if ! command -v nvim &> /dev/null; then
        warn "Neovim not found. Installing..."
        
        if command -v apt-get &> /dev/null; then
            sudo apt-get update && sudo apt-get install -y neovim
        elif command -v pacman &> /dev/null; then
            sudo pacman -S --noconfirm neovim
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y neovim
        else
            error "Could not install neovim. Please install manually."
            exit 1
        fi
        
        success "Neovim installed"
    else
        success "Neovim already installed"
    fi
    
    # Backup existing config if it exists
    if [ -d "$CONFIG_DIR" ]; then
        log "Backing up existing nvim config..."
        mv "$CONFIG_DIR" "$CONFIG_DIR.backup.$(date +%Y%m%d-%H%M%S)"
        success "Existing config backed up"
    fi
    
    # Clone nvim config
    log "Cloning nvim config..."
    git clone -b "$BRANCH" "$NVIM_REPO_URL" "$CONFIG_DIR"
    
    success "Nvim config installed!"
    log ""
    log "Next steps:"
    log "1. Run 'nvim' to start neovim"
    log "2. Let lazy.nvim install plugins automatically"
    log "3. Restart nvim once plugins are installed"
    log ""
    log "For full dotfiles setup, use:"
    log "curl -sSL https://raw.githubusercontent.com/amitrahman1026/dotfiles/chezmoi-migration/install-chezmoi.sh | bash"
}

# Handle help
if [[ "${1:-}" == "-h" ]] || [[ "${1:-}" == "--help" ]]; then
    usage
    exit 0
fi

install_nvim_config