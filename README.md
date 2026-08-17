# My Dotfiles 🌹

My personal terminal setup: **Neovim**, **tmux**, **WezTerm**, **lazygit**, and **zsh** (with Powerlevel10k).

This repo lets me set up a brand new Mac exactly like this one, in a few minutes.

## What's inside

| Tool     | Config location here      | Goes to                  |
| -------- | -------------------------- | ------------------------- |
| Neovim   | `nvim/` (submodule)         | `~/.config/nvim`           |
| tmux     | `tmux/` (submodule)         | `~/.config/tmux`           |
| WezTerm  | `wezterm/.wezterm.lua`      | `~/.wezterm.lua`           |
| zsh      | `zsh/.zshrc`, `zsh/.p10k.zsh` | `~/.zshrc`, `~/.p10k.zsh` |
| git      | `git/.gitconfig`            | `~/.gitconfig`             |

`nvim/` and `tmux/` are **git submodules** — they point to my other two repos
([nvim-config](https://github.com/Andhar7/nvim-config) and
[best_tmux-config](https://github.com/Andhar7/best_tmux-config)) so I only
maintain those configs in one place.

`Brewfile` lists every command-line tool and app needed (Homebrew installs them all in one step).

## How to install on a new Mac

1. **Install git** if it's not already there (macOS will offer to install
   Command Line Tools the first time you run `git` — accept that).

2. **Clone this repo** (note the `--recurse-submodules` flag — this also pulls
   the nvim and tmux configs):

   ```bash
   git clone --recurse-submodules git@github.com:Andhar7/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

   If you cloned without that flag by mistake, fix it with:

   ```bash
   git submodule update --init --recursive
   ```

3. **Run the installer**:

   ```bash
   ./install.sh
   ```

   This will:
   - Install Homebrew if it's missing
   - Install neovim, tmux, wezterm, lazygit, git, gh, powerlevel10k, zsh plugins, and the MesloLGS Nerd Font
   - Link every config file into the right place (any existing file is backed
     up first, as `filename.bak`, never deleted)

4. **Open a new terminal window** (or run `exec zsh`) — the new prompt, tmux
   config, and everything else should now be active.

5. **Open WezTerm** — it will pick up `~/.wezterm.lua` automatically.

## Updating

If I improve my nvim or tmux config later, I do it inside `nvim-config` or
`best_tmux-config` directly (they're their own repos). To pull those updates
into a machine using this dotfiles repo:

```bash
cd ~/dotfiles
git submodule update --remote --merge
```

## Notes

- `lazygit` config is left at its defaults (nothing custom to sync yet).
- `.gitconfig` contains my name/email — edit it if setting this up for
  someone else.
