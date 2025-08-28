# Dotfiles Repository

A cross-platform dotfiles setup managed with [chezmoi](https://chezmoi.io) for seamless configuration across macOS and Linux systems.

## Quick Installation

### Full Dotfiles Setup
```bash
# One-liner installation
curl -sSL https://raw.githubusercontent.com/amitrahman1026/dotfiles/chezmoi-migration/install-chezmoi.sh | bash

# Or with options
curl -sSL https://raw.githubusercontent.com/amitrahman1026/dotfiles/chezmoi-migration/install-chezmoi.sh | bash -s -- --dry-run
```

### Quick Neovim Setup (Servers Only)
```bash
# For quick server setups - just neovim config
curl -sSL https://raw.githubusercontent.com/amitrahman1026/dotfiles/chezmoi-migration/scripts/quick-nvim-setup.sh | bash
```

## What's Included

- **Shell**: ZSH with Oh My Zsh + Powerlevel10k theme
- **Editor**: Neovim with comprehensive plugin setup
- **Git**: Configured with signing and aliases
- **Development**: Node.js, Python, Go, Rust tooling
- **macOS**: Homebrew packages and system preferences
- **Linux**: Package management for Arch/Ubuntu/Fedora

## Manual Installation

1. Install chezmoi:
   ```bash
   sh -c "$(curl -fsLS get.chezmoi.io)"
   ```

2. Initialize with your dotfiles:
   ```bash
   chezmoi init --branch=chezmoi-migration https://github.com/amitrahman1026/dotfiles.git
   ```

3. Preview changes:
   ```bash
   chezmoi diff
   ```

4. Apply configuration:
   ```bash
   chezmoi apply
   ```

## Daily Usage

### Making Changes
```bash
# Edit configuration files
chezmoi edit ~/.zshrc
chezmoi edit ~/.gitconfig

# Apply changes
chezmoi apply

# Or edit and apply in one step
chezmoi edit --apply ~/.zshrc
```

### Keeping Up to Date
```bash
# Update from remote repository
chezmoi update

# Or manually
chezmoi git pull -- --rebase && chezmoi apply
```

### Managing Neovim Config

The neovim configuration is managed directly within this dotfiles repository but also synced to a separate repository for sharing and quick server setups.

#### Primary Workflow (recommended):
```bash
# Edit nvim config through chezmoi
chezmoi edit ~/.config/nvim/init.lua
chezmoi apply

# Commit changes to dotfiles
cd $(chezmoi source-path)
git add . && git commit -m "Update nvim config"
git push
```

#### Sync to Separate Nvim Repo:
```bash
# Sync changes to standalone nvim repository
./scripts/sync-nvim.sh                  # To main branch
./scripts/sync-nvim.sh sandbox-server   # To server branch
```

## Testing

Test the configuration in isolated Docker containers:

```bash
# Build and run tests
cd docker/
docker-compose up -d

# Test in Ubuntu container
docker exec -it dotfiles-ubuntu-test zsh

# Test in Arch container  
docker exec -it dotfiles-arch-test zsh

# Run automated tests
./test-runner.sh chezmoi-migration
```

## Platform-Specific Features

### macOS
- Homebrew package management
- macOS system preferences via `.macos` script
- GUI applications and fonts
- Development tools (Xcode, STM32, etc.)

### Linux
- Multi-distro support (Arch, Ubuntu, Fedora)
- Lightweight server configurations
- Terminal-focused setup

## Repository Structure

```
├── .chezmoi.toml.tmpl              # Dynamic chezmoi configuration
├── dot_gitconfig.tmpl              # Git configuration with templating
├── dot_zshrc.tmpl                  # ZSH configuration (OS-aware)
├── dot_config/
│   └── nvim/                       # Neovim configuration
├── scripts/
│   ├── sync-nvim.sh               # Sync nvim to separate repo
│   ├── quick-nvim-setup.sh        # Server nvim quick setup
│   ├── fsb.sh                     # FZF git branch switcher
│   └── fshow.sh                   # FZF git show
├── run_once_*                     # Setup scripts (OS-specific)
├── docker/                        # Testing infrastructure
└── install-chezmoi.sh             # Bootstrap script
```

## Security

- GPG signing configured for commits
- Sensitive data templated per machine
- No hardcoded secrets in repository

## Contributing

Feel free to fork and adapt for your own use. The configuration is designed to be modular and extensible.

## Migration Notes

This repository has been migrated from a traditional symlink-based approach to chezmoi for better cross-platform support and templating capabilities. The old `install.sh` approach is deprecated in favor of the chezmoi workflow.

### Legacy Branches
- `master`: Original symlink-based setup (deprecated)
- `sandbox-server`: Linux server configuration (deprecated)  
- `chezmoi-migration`: Current implementation

## Useful Commands

```bash
# See what chezmoi manages
chezmoi managed

# Edit chezmoi config
chezmoi edit-config

# Run setup scripts again
chezmoi state delete-bucket --bucket=scriptState
chezmoi apply

# Troubleshooting
chezmoi doctor
```