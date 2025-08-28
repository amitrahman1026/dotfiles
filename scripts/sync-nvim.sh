#!/bin/bash

set -euo pipefail

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

warn() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Configuration
DOTFILES_REPO=$(git -C "$(dirname "$0")/.." rev-parse --show-toplevel)
NVIM_SOURCE_DIR="$DOTFILES_REPO/dot_config/nvim"
NVIM_REPO_URL="git@github.com:amitrahman1026/nvim-config.git"  # Replace with your actual nvim repo
TEMP_DIR=$(mktemp -d)
BRANCH=${1:-"main"}

cleanup() {
    rm -rf "$TEMP_DIR"
}

trap cleanup EXIT

sync_to_nvim_repo() {
    log "Syncing nvim config to separate repository..."
    
    if [ ! -d "$NVIM_SOURCE_DIR" ]; then
        error "Nvim source directory not found: $NVIM_SOURCE_DIR"
        exit 1
    fi
    
    # Clone the nvim repo to temp directory
    log "Cloning nvim repository..."
    git clone "$NVIM_REPO_URL" "$TEMP_DIR/nvim-repo"
    
    cd "$TEMP_DIR/nvim-repo"
    
    # Checkout or create the target branch
    if git rev-parse --verify "$BRANCH" >/dev/null 2>&1; then
        git checkout "$BRANCH"
    else
        git checkout -b "$BRANCH"
    fi
    
    # Remove existing files (except .git)
    find . -maxdepth 1 ! -name '.' ! -name '..' ! -name '.git' -exec rm -rf {} +
    
    # Copy files from dotfiles nvim config
    log "Copying nvim config files..."
    cp -r "$NVIM_SOURCE_DIR/"* .
    
    # Check if there are changes
    if git diff --quiet && git diff --cached --quiet; then
        success "No changes to sync"
        exit 0
    fi
    
    # Add and commit changes
    git add .
    
    # Get the latest commit message from dotfiles repo for context
    DOTFILES_COMMIT=$(git -C "$DOTFILES_REPO" log -1 --pretty=format:"%h: %s")
    
    git commit -m "Sync from dotfiles: $DOTFILES_COMMIT

Synced from dotfiles repository at $(date)"
    
    # Push changes
    log "Pushing changes to nvim repository..."
    git push origin "$BRANCH"
    
    success "Successfully synced nvim config to separate repository"
    log "Nvim repo updated with latest changes from dotfiles"
}

# Usage information
usage() {
    echo "Usage: $0 [branch]"
    echo "Sync nvim config from dotfiles to separate nvim repository"
    echo ""
    echo "Arguments:"
    echo "  branch    Target branch in nvim repo (default: main)"
    echo ""
    echo "Examples:"
    echo "  $0                    # Sync to main branch"
    echo "  $0 sandbox-server     # Sync to sandbox-server branch"
}

# Check command line arguments
if [[ "${1:-}" == "-h" ]] || [[ "${1:-}" == "--help" ]]; then
    usage
    exit 0
fi

# Main execution
log "Starting nvim config sync..."
log "Source: $NVIM_SOURCE_DIR"
log "Target branch: $BRANCH"

sync_to_nvim_repo

success "Sync completed!"