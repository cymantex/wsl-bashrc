############################
# CLI Tools - Initialization
############################
# Homebrew
if test -f /home/linuxbrew/.linuxbrew/bin/brew; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# NVM
if test -d "$HOME/.nvm"; then
  export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

# Krew
if test -d "$HOME/.krew"; then
  export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
fi

# Go
if test -d /usr/local/go; then
  export PATH=$PATH:/usr/local/go/bin
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

printCliLinks() {
  printTitle "Links to CLI tools:"
  echo "DevTools:"
  echo "jq: https://jqlang.github.io/jq/tutorial"
  echo "q: https://harelba.github.io/q"
  echo "xmllint: https://gnome.pages.gitlab.gnome.org/libxml2/xmllint.html"
  echo "neovim kickstart: https://github.com/nvim-lua/kickstart.nvim"
  echo "bat: https://github.com/sharkdp/bat"
  echo -e "bat-extras: https://github.com/eth-p/bat-extras\n"

  echo "Package managers:"
  echo "nvm: https://github.com/nvm-sh/nvm"
  echo -e "brew: https://brew.sh\n"

  echo "WSL:"
  echo -e "wslu: https://wslutiliti.es/wslu/\n"

  echo "Kubernetes:"
  echo "k9s: https://k9scli.io"
  echo "kubectl: https://kubernetes.io/docs/reference/kubectl/cheatsheet"
  echo "kubectl krew: https://krew.sigs.k8s.io/"
  echo -e "kubectx: https://github.com/ahmetb/kubectx\n"

  echo "AWS:"
  echo "aws: https://docs.aws.amazon.com/cli/"
  echo -e "sam: https://github.com/aws/aws-sam-cli\n"
}