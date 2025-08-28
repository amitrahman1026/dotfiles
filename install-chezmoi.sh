#!/bin/bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Default values
REPO="https://github.com/amitrahman1026/dotfiles.git"
BRANCH="chezmoi-migration"
DRY_RUN=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --branch)
            BRANCH="$2"
            shift 2
            ;;
        --repo)
            REPO="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [options]"
            echo "Options:"
            echo "  --dry-run    Show what would be applied without making changes"
            echo "  --branch     Specify git branch (default: chezmoi-migration)"
            echo "  --repo       Specify git repository (default: amitrahman1026/dotfiles)"
            echo "  -h, --help   Show this help message"
            exit 0
            ;;
        *)
            error "Unknown option: $1"
            exit 1
            ;;
    esac
done

log "Starting dotfiles installation with chezmoi..."
log "Repository: $REPO"
log "Branch: $BRANCH"
log "Dry run: $DRY_RUN"

# Install chezmoi if not already installed
if ! command -v chezmoi &> /dev/null; then
    log "Installing chezmoi..."
    sh -c "$(curl -fsLS https://get.chezmoi.io)"
    success "Chezmoi installed"
else
    success "Chezmoi already installed"
fi

# Initialize chezmoi with the dotfiles repository
log "Initializing chezmoi with dotfiles repository..."
if chezmoi init --branch="$BRANCH" "$REPO"; then
    success "Chezmoi initialized successfully"
else
    error "Failed to initialize chezmoi"
    exit 1
fi

# Show what would be applied
log "Preview of changes that will be applied:"
echo "========================================"
chezmoi diff || true
echo "========================================"

if [ "$DRY_RUN" = true ]; then
    warn "Dry run mode - no changes will be applied"
    log "To apply these changes, run: chezmoi apply"
    exit 0
fi

# Ask for confirmation before applying
read -p "Do you want to apply these changes? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    warn "Installation cancelled by user"
    exit 0
fi

# Apply the changes
log "Applying dotfiles..."
if chezmoi apply; then
    success "Dotfiles applied successfully!"
else
    error "Failed to apply dotfiles"
    exit 1
fi

log "Installation completed!"
log ""
log "Next steps:"
log "- Restart your shell or run: source ~/.zshrc"
log "- Configure p10k if this is your first time: p10k configure"
log "- Update dotfiles anytime with: chezmoi update"