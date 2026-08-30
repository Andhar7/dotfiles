#!/usr/bin/env bash
# Gurudev's dotfiles installer — sets up nvim, tmux, wezterm, lazygit, zsh
# Run from inside the dotfiles folder: ./install.sh
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Dotfiles directory: $DOTFILES_DIR"

# 1. Install Homebrew if missing
if ! command -v brew >/dev/null 2>&1; then
	echo "==> Homebrew not found, installing..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"
fi

# 2. Install all tools from the Brewfile
echo "==> Installing packages from Brewfile..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

# 3. Link a config file/dir into place, backing up anything already there
link() {
	local src="$1"
	local dest="$2"
	if [ -e "$dest" ] && [ ! -L "$dest" ]; then
		echo "==> Backing up existing $dest -> $dest.bak"
		mv "$dest" "$dest.bak"
	fi
	mkdir -p "$(dirname "$dest")"
	ln -sfn "$src" "$dest"
	echo "==> Linked $dest -> $src"
}

echo "==> Linking config files..."
link "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
link "$DOTFILES_DIR/tmux" "$HOME/.config/tmux"
link "$DOTFILES_DIR/wezterm/.wezterm.lua" "$HOME/.wezterm.lua"
link "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
link "$DOTFILES_DIR/zsh/.p10k.zsh" "$HOME/.p10k.zsh"
link "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"

# 4. Install TPM (Tmux Plugin Manager) and pull the tmux plugins
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
	echo "==> Installing TPM (Tmux Plugin Manager)..."
	git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi
echo "==> Installing tmux plugins..."
# install_plugins needs a live tmux server with our config sourced
# (that's what sets TMUX_PLUGIN_MANAGER_PATH) — spin up a throwaway
# session for it if nothing is running yet.
tmux start-server
tmux new-session -d -s _tpm_install -c "$HOME" 2>/dev/null || true
tmux source-file "$HOME/.config/tmux/tmux.conf"
"$TPM_DIR/bin/install_plugins"
tmux kill-session -t _tpm_install 2>/dev/null || true

echo ""
echo "==> Done! 🙏"
echo "==> Open a new terminal window (or run: exec zsh) to see everything active."
