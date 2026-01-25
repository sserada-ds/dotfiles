# Modern CLI Tools Initialization

# zoxide - smart cd
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# atuin - shell history
if command -v atuin &>/dev/null; then
  eval "$(atuin init zsh)"
fi
