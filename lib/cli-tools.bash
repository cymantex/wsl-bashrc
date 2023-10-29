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

# Maven
export MAVEN_VERSION=3.9.5

if test -d /opt/apache-maven-"$MAVEN_VERSION"; then
  M2_HOME="/opt/apache-maven-$MAVEN_VERSION"
  PATH="$M2_HOME/bin:$PATH"
fi

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