# dotfiles

My shell, git, editor, terminal and browser setup, for my Mac and my Arch sandbox (and maybe Windows one day). [chezmoi](https://www.chezmoi.io) applies it all. Everything lives on `master`; when the Mac and Linux need different things, templates handle it instead of a branch per machine.

## New machine

```bash
git clone https://github.com/amitrahman1026/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

No admin rights needed. `install.sh` gets chezmoi (through Homebrew if it's there, otherwise into `~/.local/bin`), asks whether this is a `personal` or `work` machine and which git email to use, shows the diff, and applies once I say yes.

On a personal machine it also asks for the age key passphrase. That's in Bitwarden as `chezmoi age key passphrase`.

The answers end up in `~/.config/chezmoi/chezmoi.toml`. Run `chezmoi init --source ~/dotfiles` again to change them.

## Personal vs work

| | personal | work |
|---|---|---|
| Brewfile, agent-workspace | yes | no |
| Secrets (ssh config, servers.conf, GPG key) | yes | no |
| Git commit signing, https→ssh rewrite | yes | no |
| nvim config clone | over ssh | over https |
| Shell, editors, tmux, Zen | yes | yes |

On a work machine where I'm not admin, nvim 0.12 and tree-sitter-cli 0.26+ probably need a user-level install, e.g. the release tarballs in `~/.local`.

## Secrets

This repo is public, so anything sensitive is age-encrypted and only the ciphertext is committed:

| File | Source |
|---|---|
| `~/.ssh/config` | `home/private_dot_ssh/encrypted_config.age` |
| `~/.config/fss/servers.conf` | `home/private_dot_config/fss/encrypted_servers.conf.age` |
| GPG signing key 490CB7F4 | `secrets/gpg-key.asc.age` (`run_onchange_after_40-gpg-key.sh` imports and trusts it) |

The age key is in `secrets/age-key.txt.age`, locked with the passphrase from Bitwarden. `run_onchange_before_00-age-key.sh` decrypts it to `~/.config/chezmoi/key.txt` the first time on each machine, and after that I never need Bitwarden for this.

- To edit a secret: `chezmoi edit ~/.ssh/config`, or edit the file directly and `chezmoi re-add ~/.ssh/config`.
- After `fss add`: `chezmoi re-add ~/.ssh/config ~/.config/fss/servers.conf`, then commit.
- If the GPG key changes (new expiry, say): `gpg --export-secret-keys --armor 490CB7F4 | chezmoi encrypt > secrets/gpg-key.asc.age`, commit, and the other machines pick it up on their next `chezmoi apply`.
- SSH private keys aren't in here. Every machine gets its own.

## Day to day

| Task | Command |
|---|---|
| See what chezmoi would change | `chezmoi diff` |
| Apply the repo | `chezmoi apply` |
| Pull this repo and the externals, then apply | `chezmoi update` |
| Save a file I edited in place back to the repo | `chezmoi re-add ~/.zshrc` |
| Edit a template | Edit it under `home/`, then `chezmoi apply` |

chezmoi writes real files, not symlinks. When an app rewrites its own config, `chezmoi diff` shows it, and I either `chezmoi re-add` to keep the change or `chezmoi apply` to throw it away.

## What's where

```
home/                  chezmoi source state (.chezmoiroot). Paths are relative to ~.
  dot_zshrc.tmpl       zsh config, with darwin and linux sections
  dot_p10k.zsh.tmpl    Powerlevel10k; font mode depends on the OS
  dot_gitconfig.tmpl, private_dot_config/git/ignore, dot_vimrc, dot_tmux.conf, dot_ideavimrc
  private_Library/...  VS Code and Cursor settings (macOS only)
  .chezmoiexternal.toml.tmpl  git repos chezmoi clones and pulls (see below)
  run_onchange_*       scripts that rerun when their inputs change
brew/Brewfile          Homebrew packages; the brew script reruns when this changes
zen/                   Zen settings the Mozilla account doesn't sync
iterm2/                iTerm2 reads its prefs straight from this folder
macos/.macos           macOS defaults, run by hand: source macos/.macos
scripts/               fzf helpers fsb, fshow, fss (aliased in zshrc)
secrets/               age-encrypted age key and GPG key
cp_templates/          competitive programming template (nvim competitest uses it)
```

## External repos

chezmoi clones these and pulls them weekly on `chezmoi update`. They're normal git repos, so I edit and commit in place. Pulls are fast-forward only, so push local commits before running `chezmoi update`.

| Path | Repo |
|---|---|
| `~/.config/nvim` | `amitrahman1026/init.lua`. One `main` branch for every machine; differences go in Lua checks, not branches. |
| `~/agent-workspace` | `amitrahman1026/agent-workspace` (private): Claude Code rules, skills and settings. `run_onchange_after_30-agent-workspace.sh` runs its `install.sh`, which links them into `~/.claude`. |
| `~/.oh-my-zsh`, plus its powerlevel10k and zsh-autosuggestions | upstream |
| `~/.tmux/plugins/tpm` | upstream |

## Zen

The Mozilla account only syncs some of Zen's `zen.*` prefs, so the rest live here:

- `zen/user.js`: layout prefs (`zen.view.*`, `browser.uiCustomization.state`), plus `xpinstall.signatures.required=false` so unsigned add-ons install.
- `zen/zen-keyboard-shortcuts.json`: keyboard shortcuts.

`run_onchange_after_20-zen.sh` copies both into every Zen profile in `profiles.ini`. Quit Zen before `chezmoi apply`, or it overwrites the shortcuts file on exit.

Zen re-reads `user.js` on every start, so layout tweaks made in the UI get reset on restart. To keep one, run `zen/capture.sh` and commit.
