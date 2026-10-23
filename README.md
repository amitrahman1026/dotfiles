# dotfiles

My shell, git, editor, terminal and browser settings for macOS and Arch Linux. [chezmoi](https://www.chezmoi.io) applies them from this repo. All machines use the `master` branch. Templates handle the differences between operating systems.

## Set up a new machine

```bash
git clone git@github.com:amitrahman1026/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

`install.sh` installs chezmoi, shows the diff, and applies the changes when you confirm.

## Daily use

| Task | Command |
|---|---|
| See what chezmoi will change | `chezmoi diff` |
| Apply this repo to the machine | `chezmoi apply` |
| Pull this repo and the external repos, then apply | `chezmoi update` |
| Copy a file that you changed in place back into the repo | `chezmoi re-add ~/.zshrc` |
| Edit a template | Edit the file under `home/`, then run `chezmoi apply` |

chezmoi writes copies, not symlinks. If an app changes its own config file, `chezmoi diff` shows the change. Run `chezmoi re-add` to keep it, or `chezmoi apply` to discard it.

## Layout

```
home/                  chezmoi source state (.chezmoiroot). Paths are relative to ~.
  dot_zshrc.tmpl       zsh config. Sections for darwin and linux.
  dot_p10k.zsh.tmpl    Powerlevel10k. The font mode depends on the OS.
  dot_gitconfig, dot_config/git/ignore, dot_vimrc, dot_tmux.conf, dot_ideavimrc
  Library/...          VS Code and Cursor settings (macOS only)
  .chezmoiexternal.toml  Git repos that chezmoi clones and pulls (see below)
  run_onchange_*       Scripts that run when their inputs change
brew/Brewfile          Homebrew packages. The brew script runs when this file changes.
zen/                   Zen browser settings that the Mozilla account does not sync
iterm2/                iTerm2 reads its preferences directly from this folder
macos/.macos           macOS defaults. Run it manually: source macos/.macos
scripts/               fzf helpers: fsb, fshow, fss (aliases in zshrc)
cp_templates/          Competitive programming template (used by nvim competitest)
```

## External repos

`.chezmoiexternal.toml` clones these repos and pulls them weekly on `chezmoi update`. Edit them and commit in place. They are normal git repos.

| Path | Repo |
|---|---|
| `~/.config/nvim` | `amitrahman1026/init.lua`. Use one `main` branch. Put machine differences in Lua checks, not in branches. |
| `~/agent-workspace` | `amitrahman1026/agent-workspace` (private). Claude Code rules, skills and settings. `run_onchange_after_30-agent-workspace.sh` runs its `install.sh`, which links them into `~/.claude`. |
| `~/.oh-my-zsh` and its powerlevel10k and zsh-autosuggestions | upstream |
| `~/.tmux/plugins/tpm` | upstream |

## Zen browser

The Mozilla account syncs only some `zen.*` prefs. This repo keeps the rest:

- `zen/user.js`: the layout prefs (`zen.view.*`, `browser.uiCustomization.state`) and `xpinstall.signatures.required=false` for unsigned add-ons.
- `zen/zen-keyboard-shortcuts.json`: keyboard shortcuts.

`run_onchange_after_20-zen.sh` copies both files into each Zen profile listed in `profiles.ini`. Quit Zen before `chezmoi apply`, or Zen rewrites the shortcuts file when it exits.

Zen reads `user.js` at every start, so a layout change made in the Zen UI does not last after a restart. To keep a change, run `zen/capture.sh` and commit the result.

## Not in this repo

This repo is public, so it does not contain `~/.ssh/config` or `scripts/servers.conf` (git ignores it).
