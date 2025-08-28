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

# Test chezmoi installation in container
test_chezmoi_install() {
    local container=$1
    local branch=${2:-main}
    
    log "Testing chezmoi installation in $container container..."
    
    # Test basic chezmoi functionality
    docker exec -i $container bash << EOF
        # Test chezmoi is installed
        chezmoi --version || exit 1
        
        # Test initialization from your repo
        echo "Testing chezmoi init with branch: $branch"
        chezmoi init --branch=$branch https://github.com/amitrahman1026/dotfiles.git || exit 1
        
        # Show what would be applied (dry run)
        echo "=== Dry run output ==="
        chezmoi diff || true
        
        # List managed files
        echo "=== Managed files ==="
        chezmoi managed || true
        
        echo "=== Source directory contents ==="
        ls -la \$(chezmoi source-path) || true
EOF
    
    if [ $? -eq 0 ]; then
        success "Chezmoi installation test passed for $container"
    else
        error "Chezmoi installation test failed for $container"
        return 1
    fi
}

# Test specific configuration deployment
test_config_deployment() {
    local container=$1
    
    log "Testing configuration deployment in $container..."
    
    docker exec -i $container bash << EOF
        # Apply configurations (dry run first)
        echo "=== Applying configurations ==="
        chezmoi apply --dry-run || true
        
        # Show any templated files
        echo "=== Template execution test ==="
        chezmoi execute-template << 'TEMPLATE' || true
OS: {{ .chezmoi.os }}
Hostname: {{ .chezmoi.hostname }}
Username: {{ .chezmoi.username }}
TEMPLATE
EOF
}

# Main test function
main() {
    local test_branch=${1:-"chezmoi-migration"}
    
    log "Starting dotfiles testing with branch: $test_branch"
    
    # Build containers
    log "Building test containers..."
    if command -v docker-compose &> /dev/null; then
        docker-compose build
    else
        docker compose build
    fi
    
    # Start containers
    log "Starting containers..."
    if command -v docker-compose &> /dev/null; then
        docker-compose up -d
    else
        docker compose up -d
    fi
    
    # Wait for containers to be ready
    sleep 5
    
    # Test each container
    for container in ubuntu-test arch-test; do
        log "Testing container: dotfiles-$container"
        
        if test_chezmoi_install "dotfiles-$container" "$test_branch"; then
            test_config_deployment "dotfiles-$container"
        else
            error "Skipping config deployment test for $container due to install failure"
        fi
        
        echo "----------------------------------------"
    done
    
    # Cleanup
    log "Test completed. Containers are still running for inspection."
    log "To inspect: docker exec -it dotfiles-ubuntu-test zsh"
    if command -v docker-compose &> /dev/null; then
        log "To cleanup: docker-compose down"
    else
        log "To cleanup: docker compose down"
    fi
}

# Check if branch argument provided
if [ $# -eq 0 ]; then
    warn "No branch specified, using 'chezmoi-migration'"
    warn "Usage: $0 [branch-name]"
    main
else
    main "$1"
fi