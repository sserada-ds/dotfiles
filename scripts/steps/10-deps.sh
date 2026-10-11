# desc: 依存パッケージ (brew / apt / pacman / dnf)
# default: on

BREW_PKGS=(
  neovim git tmux fzf bat eza zoxide ripgrep fd prettier shfmt stylua pipx node
  git-delta jq gh lazygit hyperfine tlrc direnv httpie
  glow tokei dust bottom procs sd just watchexec duf
  atuin pv mkcert zellij navi doggo jless bandwhich silicon
)

# 未導入なら "$1" を実行 ($2 = コマンド名)
install_unless() {
  local cmd="$1"
  shift
  if has "$cmd"; then
    ok "$cmd は既にインストール済み"
  else
    info "$cmd をインストール中..."
    "$@"
  fi
}

install_gh_apt() {
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" |
    sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
  sudo apt update
  sudo apt install -y gh
}

install_node_apt() {
  curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
  sudo apt install -y nodejs
}

install_delta_apt() {
  local tag
  tag="$(github_latest_tag dandavison/delta)"
  if [[ -z "$tag" ]]; then
    warn "git-delta のバージョン取得に失敗"
    return 0
  fi
  local deb
  deb="$(mktemp -t git-delta.XXXXXX)"
  curl -fsSL "https://github.com/dandavison/delta/releases/download/${tag}/git-delta_${tag}_$(dpkg --print-architecture).deb" -o "$deb"
  sudo dpkg -i "$deb"
  rm -f "$deb"
}

install_eza_apt() {
  sudo mkdir -p /etc/apt/keyrings
  wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
  echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list >/dev/null
  sudo chmod 644 /etc/apt/keyrings/gierens.gpg
  sudo apt update
  sudo apt install -y eza
}

install_shfmt_linux() {
  local tag arch
  tag="$(github_latest_tag mvdan/sh)"
  if [[ -z "$tag" ]]; then
    warn "shfmt のバージョン取得に失敗"
    return 0
  fi
  arch="$(dpkg --print-architecture)"
  [[ "$arch" == "amd64" ]] || arch="arm64"
  curl -fsSL "https://github.com/mvdan/sh/releases/download/${tag}/shfmt_${tag}_linux_${arch}" -o "$HOME/.local/bin/shfmt"
  chmod +x "$HOME/.local/bin/shfmt"
}

install_stylua_linux() {
  local tag arch zip
  tag="$(github_latest_tag JohnnyMorganz/StyLua)"
  if [[ -z "$tag" ]]; then
    warn "stylua のバージョン取得に失敗"
    return 0
  fi
  if [[ "$(dpkg --print-architecture)" == "amd64" ]]; then arch="linux-x86_64"; else arch="linux-aarch64"; fi
  zip="$(mktemp -t stylua.XXXXXX)"
  curl -fsSL "https://github.com/JohnnyMorganz/StyLua/releases/download/${tag}/stylua-${arch}.zip" -o "$zip"
  unzip -o "$zip" -d "$HOME/.local/bin/"
  chmod +x "$HOME/.local/bin/stylua"
  rm -f "$zip"
}

install_cargo_tools() {
  if ! has cargo; then
    info "Rust をインストール中..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    # shellcheck disable=SC1091
    . "$HOME/.cargo/env"
  fi
  if has cargo; then
    cargo install bottom procs sd du-dust tokei hyperfine just watchexec-cli tealdeer duf
  else
    err "cargo が見つかりません。Rust ツール群をスキップ"
  fi
}

deps_apt() {
  info "apt を使用してインストール (Ubuntu/Debian)"
  sudo apt update
  sudo apt install -y neovim git tmux fzf bat ripgrep fd-find direnv httpie curl jq pipx \
    unzip build-essential libnss3-tools pv

  mkdir -p "$HOME/.local/bin"
  if has batcat && ! has bat; then
    ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
    ok "bat -> batcat"
  fi
  if has fdfind && ! has fd; then
    ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
    ok "fd -> fdfind"
  fi

  install_unless gh install_gh_apt
  install_unless node install_node_apt
  if has npm; then sudo npm install -g prettier || true; else warn "npm が見つかりません。prettier をスキップ"; fi
  install_unless delta install_delta_apt
  install_unless eza install_eza_apt
  install_unless zoxide bash -c 'curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh'
  install_unless atuin bash -c "curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh"
  install_unless shfmt install_shfmt_linux
  install_unless stylua install_stylua_linux
  install_cargo_tools

  warn "以下は手動インストールを推奨: lazygit, glow, navi, jless, doggo, bandwhich, silicon, zellij"
}

run() {
  if has brew; then
    info "Homebrew を使用してインストール"
    brew install "${BREW_PKGS[@]}"
  elif has apt; then
    deps_apt
  elif has pacman; then
    info "pacman を使用してインストール (Arch Linux)"
    sudo pacman -S --noconfirm neovim git tmux fzf bat eza zoxide ripgrep fd \
      git-delta jq github-cli lazygit hyperfine tldr direnv httpie \
      glow tokei dust bottom procs sd just watchexec duf \
      atuin pv mkcert zellij navi doggo bandwhich silicon
  elif has dnf; then
    info "dnf を使用してインストール (Fedora/RHEL)"
    sudo dnf install -y neovim git tmux fzf bat eza zoxide ripgrep fd-find \
      git-delta jq gh lazygit direnv httpie
    warn "Rust 系 (hyperfine glow tokei du-dust bottom procs sd just watchexec tealdeer) は cargo install を推奨"
  else
    err "サポートされているパッケージマネージャーが見つかりません"
    echo "  手動で導入してください: neovim git fzf bat eza zoxide ripgrep fd git-delta jq gh lazygit" >&2
    return 1
  fi
  ok "パッケージのインストール完了"
}
