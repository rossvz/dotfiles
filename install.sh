#!/usr/bin/env bash
# Dotfiles installer — works on macOS and Linux (Coder workspaces).
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="$(uname -s)"

link() {
  mkdir -p "$(dirname "$2")"
  ln -sfn "$1" "$2"
}

install_nvim_linux() {
  echo "  installing neovim..."
  local arch
  case "$(uname -m)" in
    aarch64) arch="arm64" ;;
    x86_64)  arch="x86_64" ;;
    *) echo "  unsupported arch for nvim install, skipping"; return 1 ;;
  esac
  local url="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${arch}.tar.gz"
  # Extract full tarball into /usr/local — binary + runtime files (share/nvim/runtime/).
  # Extracting only the binary breaks lua module loading.
  curl -fsSL "$url" | tar xz --strip-components=1 -C /usr/local
  echo "  neovim $(nvim --version | head -1) installed"
}

echo "Installing dotfiles from $REPO..."

# --- nvim ---
if [ "$OS" = "Linux" ] && ! command -v nvim &>/dev/null; then
  install_nvim_linux || true
fi
if command -v nvim &>/dev/null; then
  link "$REPO/nvim" ~/.config/nvim
  echo "  nvim: linked config"
  echo "  nvim: syncing plugins (lazy.nvim)..."
  nvim --headless "+Lazy! sync" +qa 2>/dev/null || true
  echo "  nvim: done"
fi

# --- dexter LSP (Elixir) ---
if [ "$OS" = "Linux" ] && ! command -v dexter &>/dev/null; then
  echo "  installing dexter LSP..."
  dexter_arch=""
  case "$(uname -m)" in
    aarch64) dexter_arch="arm64" ;;
    x86_64)  dexter_arch="x86_64" ;;
  esac
  if [ -n "$dexter_arch" ]; then
    curl -fsSL "https://github.com/remoteoss/dexter/releases/latest/download/dexter_Linux_${dexter_arch}.tar.gz" \
      | tar xz --strip-components=1 -C /usr/local/bin "dexter_Linux_${dexter_arch}/dexter" \
      && echo "  dexter $(dexter --version 2>&1 | head -1) installed" \
      || echo "  WARNING: dexter install failed, continuing"
  fi
fi

# --- git ---
link "$REPO/gitconfig" ~/.gitconfig
link "$REPO/gitignore_global" ~/.gitignore
echo "  git: linked gitconfig + gitignore"

# --- lazygit ---
if command -v lazygit &>/dev/null; then
  link "$REPO/lazygit/config.yml" ~/.config/lazygit/config.yml
  echo "  lazygit: linked config"
fi

# --- mise (global toolchain versions) ---
# macOS ONLY. The mise GLOBAL config pins MY laptop's toolchain versions (erlang 27.0.1,
# node 23.7.0, ruby, …). On a container/remote box (e.g. a Coder emr-mono workspace) the
# toolchains are pre-baked at DIFFERENT versions and per-repo .tool-versions drives selection,
# so linking my personal global here makes mise report everything "missing" and try to reinstall.
if command -v mise &>/dev/null && [ "$OS" = "Darwin" ]; then
  link "$REPO/mise/config.toml" ~/.config/mise/config.toml
  echo "  mise: linked config"
fi

# --- tmux ---
if command -v tmux &>/dev/null; then
  link "$REPO/tmux.conf" ~/.tmux.conf
  echo "  tmux: linked config"
fi

# --- zellij ---
if command -v zellij &>/dev/null; then
  link "$REPO/zellij/config.kdl" ~/.config/zellij/config.kdl
  echo "  zellij: linked config"
fi

# --- VS Code extensions (Linux: code-server + VS Code Desktop remote) ---
if [ "$OS" = "Linux" ]; then
  # code-server (browser VS Code) — uses Open VSX, separate extension dir
  if command -v code-server &>/dev/null; then
    mkdir -p ~/.local/share/code-server/User
    link "$REPO/vscode/settings.json" ~/.local/share/code-server/User/settings.json
    link "$REPO/vscode/keybindings.json" ~/.local/share/code-server/User/keybindings.json
    ext_list="$REPO/vscode/code-server-extensions.txt"
    [ -f "$ext_list" ] || ext_list="$REPO/vscode/extensions.txt"
    while IFS= read -r ext; do
      [[ -z "$ext" || "$ext" == \#* ]] && continue
      code-server --install-extension "$ext" --force 2>/dev/null || true
    done < "$ext_list"
    echo "  code-server: settings + extensions installed"
  fi

  # VS Code Desktop remote — copy extensions from code-server (same VSIX format, works offline).
  # Run install.sh again after VS Code Desktop has connected at least once to pick up new ones.
  cs_ext_dir=~/.local/share/code-server/extensions
  vs_ext_dir=~/.vscode-server/extensions
  if [ -d "$cs_ext_dir" ] && [ -d "$vs_ext_dir" ]; then
    copied=0
    for src in "$cs_ext_dir"/*/; do
      name="$(basename "$src")"
      [ -d "$vs_ext_dir/$name" ] || { cp -r "$src" "$vs_ext_dir/$name"; copied=$((copied+1)); }
    done
    mkdir -p ~/.vscode-server/data/Machine
    link "$REPO/vscode/settings.json" ~/.vscode-server/data/Machine/settings.json
    echo "  vscode-remote: copied $copied extensions from code-server, linked settings"
  elif [ ! -d "$vs_ext_dir" ]; then
    echo "  vscode-remote: VS Code Desktop hasn't connected yet — re-run install.sh after first connect"
  fi
fi

# macOS-only tools
if [ "$OS" = "Darwin" ]; then
  if ! command -v nvim &>/dev/null && command -v brew &>/dev/null; then
    echo "  installing neovim via brew..."
    brew install neovim
  fi

  if command -v aerospace &>/dev/null; then
    link "$REPO/aerospace.toml" ~/.config/aerospace/aerospace.toml
    echo "  aerospace: linked config"
  fi

  if [ -d "$HOME/.config/ghostty" ] || command -v ghostty &>/dev/null 2>&1; then
    link "$REPO/ghostty/config" ~/.config/ghostty/config
    echo "  ghostty: linked config"
  fi

  if command -v sketchybar &>/dev/null; then
    link "$REPO/sketchybar" ~/.config/sketchybar
    echo "  sketchybar: linked config"
  fi

  if command -v borders &>/dev/null; then
    link "$REPO/borders/bordersrc" ~/.config/borders/bordersrc
    echo "  borders: linked config"
  fi

  if [ -d "$HOME/.config/karabiner" ]; then
    link "$REPO/karabiner.json" ~/.config/karabiner/karabiner.json
    echo "  karabiner: linked config"
  fi

  VSCODE_DIR="$HOME/Library/Application Support/Code/User"
  if [ -d "$VSCODE_DIR" ] || command -v code &>/dev/null; then
    mkdir -p "$VSCODE_DIR"
    link "$REPO/vscode/settings.json" "$VSCODE_DIR/settings.json"
    link "$REPO/vscode/keybindings.json" "$VSCODE_DIR/keybindings.json"
    echo "  vscode: linked settings"
  fi

  CURSOR_DIR="$HOME/Library/Application Support/Cursor/User"
  if [ -d "$CURSOR_DIR" ] || command -v cursor &>/dev/null; then
    mkdir -p "$CURSOR_DIR"
    link "$REPO/cursor/settings.json" "$CURSOR_DIR/settings.json"
    link "$REPO/cursor/keybindings.json" "$CURSOR_DIR/keybindings.json"
    echo "  cursor: linked settings"
  fi

  if command -v zed &>/dev/null; then
    link "$REPO/zed/settings.json" ~/.config/zed/settings.json
    link "$REPO/zed/keymap.json" ~/.config/zed/keymap.json
    echo "  zed: linked settings"
  fi
fi

echo "Done."
