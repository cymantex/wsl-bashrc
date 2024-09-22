printTitle() {
  echo "###############################"
  echo "$@"
  echo "###############################"
}

forceRestart() {
  echo -e "\n"
  printTitle "$1 installed - restart terminal and rerun script to continue the install"
  exit
}

disableStartUpMessages() {
  touch ~/.sudo_as_admin_successful
  touch ~/.hushlogin
}

printAlreadyInstalled() {
  echo "$1 already installed. Skipping..."
}

updateApt() {
  printTitle "Updating apt"
  sudo apt update -y
  sudo apt upgrade -y
  echo -e "\n"
}

installJenv() {
  if test -f /home/linuxbrew/.linuxbrew/bin/jenv; then
    printAlreadyInstalled "jenv"
    return
  fi

  brew install jenv || exit
}

installMaven() {
  if [[ -z "${MAVEN_VERSION}" ]]; then
    echo "MAVEN_VERSION environment variable is not set"
    exit
  fi

  if test -d /opt/apache-maven-"$MAVEN_VERSION"; then
    printAlreadyInstalled "maven"
    return 1
  fi

  wget https://dlcdn.apache.org/maven/maven-3/"$MAVEN_VERSION"/binaries/apache-maven-"$MAVEN_VERSION"-bin.tar.gz || exit
  sudo tar -xvf apache-maven-"$MAVEN_VERSION"-bin.tar.gz || exit
  sudo mv apache-maven-"$MAVEN_VERSION" /opt
  rm apache-maven-"$MAVEN_VERSION"-bin.tar.gz
  return 0
}

installGo() {
  if test -d /usr/local/go; then
    printAlreadyInstalled "go"
    return 1
  fi

  wget https://go.dev/dl/go1.21.3.linux-amd64.tar.gz
  sudo tar -C /usr/local -xzf go1.21.3.linux-amd64.tar.gz
  export PATH=$PATH:/usr/local/go/bin
  rm go1.21.3.linux-amd64.tar.gz
  return 0
}

installAwsCli() {
  if test -f /usr/bin/aws || test -f /usr/local/bin/aws; then
    printAlreadyInstalled "aws"
    return 1
  fi

  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" || exit
  unzip awscliv2.zip
  sudo ./aws/install || exit
  sudo cp /usr/local/bin/aws /usr/bin/aws
  rm awscliv2.zip
  return 0
}

installAwsSamCli() {
  if test -f /usr/bin/sam || test -f /usr/local/bin/sam; then
    printAlreadyInstalled "sam"
    return 1
  fi

  wget https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip || exit
  unzip aws-sam-cli-linux-x86_64.zip -d sam-installation
  sudo ./sam-installation/install || exit
  sudo cp /usr/local/bin/sam /usr/bin/sam
  rm aws-sam-cli-linux-x86_64.zip
  return 0
}

installKubectl() {
  if test -f /usr/bin/kubectl; then
    printAlreadyInstalled "kubectl"
    return 1
  fi

  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" || exit
  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl || exit
  sudo cp /usr/local/bin/kubectl /usr/bin/kubectl
  return 0
}

installKrew() {
  if test -d "$HOME/.krew"; then
    printAlreadyInstalled "krew"
    return 1
  fi

  (
    set -x; cd "$(mktemp -d)" &&
    OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
    ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
    KREW="krew-${OS}_${ARCH}" &&
    curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
    tar zxvf "${KREW}.tar.gz" &&
    ./"${KREW}" install krew
  ) || exit

  source "$HOME"/.bashrc
  return 0
}

installKubectx() {
  if test -f /usr/bin/kubectx; then
    printAlreadyInstalled "kubectx"
    return 1
  fi

  kubectl krew install ctx || exit
  kubectl krew install ns || exit

  touch kubectx
  chmod +x kubectx
  echo '#!/bin/bash' >> kubectx
  echo "kubectl ctx \$@" >> kubectx
  sudo mv kubectx /usr/bin/
  sudo cp /usr/bin/kubectx /usr/local/bin
  return 0
}

installHomebrew() {
  if test -f /home/linuxbrew/.linuxbrew/bin/brew; then
    printAlreadyInstalled "brew"
    return 1
  fi

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || exit
  return 0
}

installNvm() {
  if test -d "$HOME/.nvm"; then
    printAlreadyInstalled "nvm"
    return 1
  fi

  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash || exit
  source "$HOME"/.bashrc
  return 0
}

installK9s() {
  if test -f /home/linuxbrew/.linuxbrew/bin/k9s; then
    printAlreadyInstalled "k9s"
    return 1
  fi

  brew install derailed/k9s/k9s || exit
  return 0
}

installNode() {
  export NVM_DIR=$HOME/.nvm;
  source $NVM_DIR/nvm.sh;
  nvm install node || exit
}

installNeoVim() {
  if test -f /usr/bin/nvim; then
    printAlreadyInstalled "nvim"
    return 1
  fi

  sudo add-apt-repository ppa:neovim-ppa/unstable || exit
  sudo apt update
  sudo apt install neovim || exit
  git clone https://github.com/nvim-lua/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim || exit
  return 0
}

installBat() {
  if test -f /usr/bin/bat; then
    printAlreadyInstalled "bat"
    return 1
  fi

  sudo apt install bat || exit
  sudo ln -s /usr/bin/batcat /usr/bin/bat
  brew install bat-extras || exit
  return 0
}

installWslu() {
  if test -f /usr/bin/wslview; then
    printAlreadyInstalled "WSL Utilities"
    return 1
  fi

  sudo add-apt-repository -y ppa:wslutilities/wslu
  sudo apt update
  sudo apt install -y wslu
  return 0
}

installQ() {
  if test -f /usr/bin/q; then
    printAlreadyInstalled "q"
    return
  fi

  wget https://github.com/harelba/q/releases/download/v3.1.6/q-text-as-data-3.1.6-1.x86_64.deb || exit
  sudo dpkg -i q-text-as-data-3.1.6-1.x86_64.deb || exit
  rm q-text-as-data-3.1.6-1.x86_64.deb
  return 0
}

installNode() {
  if node --version &> /dev/null; then
    printAlreadyInstalled "node"
    return
  fi

  nvm install node || exit
  return 0
}

installTldr() {
  if tldr --version &> /dev/null; then
    printAlreadyInstalled "tldr"
    return
  fi

  npm install -g tldr || exit
  return 0
}

installBun() {
  if test -f ~/.bun/bin/bun; then
    printAlreadyInstalled "bun"
    return 1
  fi

  curl -fsSL https://bun.sh/install | bash
  return 0
}

installSdkMan() {
  if test -d ~/.sdkman; then
    printAlreadyInstalled "sdkman"
    return 1
  fi

  curl -s "https://get.sdkman.io" | bash
  return 0
}

installJava() {
  if java --version &> /dev/null; then
    printAlreadyInstalled "java"
    return 1
  fi

  sdk install java
  return 0
}

installGh() {
  if gh --version &> /dev/null; then
    printAlreadyInstalled "gh"
    return
  fi

  brew install gh || exit
}

_verifyInstall() {
  if "$@" &> /dev/null; then
    printf "%-20s" "$*"
    tput setaf 2 && echo "OK!"
  else
    printf "%-20s" "$*"
    tput setaf 1 && echo "ERROR!"
  fi

  tput sgr0
}

verifyCliToolInstalls() {
  _verifyInstall jq --version
  _verifyInstall q -h
  _verifyInstall xmllint --version
  _verifyInstall nvim --version
  _verifyInstall tldr --version
  _verifyInstall fzf --version
  _verifyInstall bat --version
  _verifyInstall batgrep --version

  _verifyInstall nvm --version
  _verifyInstall brew --version
  _verifyInstall sdk help

  _verifyInstall wslview --version

  _verifyInstall node --version
  _verifyInstall java --version
  _verifyInstall jenv --version
  _verifyInstall mvn --version
  _verifyInstall go version
  _verifyInstall bun --version

  _verifyInstall kubectl --help
  _verifyInstall kubectl krew -h
  _verifyInstall kubectx --help
  _verifyInstall k9s --help

  _verifyInstall aws --version
  _verifyInstall sam --version
}

_printCliLink() {
  tput setaf 6 && printf "%-18s" "$1"
  tput sgr0
  printf "%s\n" "$2"
}

printCliLinks() {
  printTitle "Links to CLI tools:"
  echo -e "\nDevTools:"
  _printCliLink "jq" "https://jqlang.github.io/jq/tutorial"
  _printCliLink "q" "https://harelba.github.io/q"
  _printCliLink "xmllint" "https://gnome.pages.gitlab.gnome.org/libxml2/xmllint.html"
  _printCliLink "tldr" "https://tldr.sh"
  _printCliLink "fzf" "https://github.com/junegunn/fzf#usage"
  _printCliLink "fdfind" "https://github.com/sharkdp/fd"
  _printCliLink "rg" "https://github.com/BurntSushi/ripgrep"
  _printCliLink "xmllint" "https://gnome.pages.gitlab.gnome.org/libxml2/xmllint.html"
  _printCliLink "tldr" "https://tldr.sh"
  _printCliLink "kickstart.nvim" "https://github.com/nvim-lua/kickstart.nvim"
  _printCliLink "bat" "https://github.com/sharkdp/bat"
  _printCliLink "bat-extras" "https://github.com/eth-p/bat-extras"
  _printCliLink "bun" "https://bun.sh/docs"

  echo -e "\nPackage managers:"
  _printCliLink "nvm" "https://github.com/nvm-sh/nvm"
  _printCliLink "brew" "https://brew.sh"

  echo -e "\nWSL:"
  _printCliLink "wslu" "https://wslutiliti.es/wslu/"

  echo -e "\nKubernetes:"
  _printCliLink "k9s" "https://k9scli.io"
  _printCliLink "kubectl" "https://kubernetes.io/docs/reference/kubectl/cheatsheet"
  _printCliLink "kubectl krew" "https://krew.sigs.k8s.io/"
  _printCliLink "kubectx" "https://github.com/ahmetb/kubectx"

  echo -e "\nAWS:"
  _printCliLink "aws" "https://docs.aws.amazon.com/cli/"
  _printCliLink "sam" "https://github.com/aws/aws-sam-cli"
}