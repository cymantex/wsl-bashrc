############################
# CLI Tools - Initialization
############################
# Homebrew
if test -f /home/linuxbrew/.linuxbrew/bin/brew; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# NVM
if test -d "${HOME}/.nvm"; then
  export NVM_DIR="${HOME}/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

# Krew
if test -d "$HOME/.krew"; then
  export PATH="$HOME/.krew/bin:$PATH"
fi

# Go
if test -d /usr/local/go; then
  export PATH=$PATH:/usr/local/go/bin
fi

#SDK Man
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# pnpm
export PNPM_HOME="/home/simer/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end

############################
# CLI Tools
############################
alias batpretty="prettybat"

installOrUpdateAllCliTools() {
  originalPath=$(pwd)
  chmod +x "$BASHRC_INSTALL"/install.bash
  cd "$BASHRC_INSTALL" || return
  ./install.bash
  cd "$originalPath" || return
}