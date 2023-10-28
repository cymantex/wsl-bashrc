printTitle() {
  echo "###############################"
  echo "$@"
  echo "###############################"
}

forceRestart() {
  printTitle "$1 installed - restart terminal and rerun script to continue the install"
  exit
}

disableStartUpMessages() {
  touch .sudo_as_admin_successful
  touch .hushlogin
}

printAlreadyInstalled() {
  echo "$1 already installed. Skipping..."
}

updateApt() {
  printTitle "Updating apt"
  sudo apt update
  sudo apt upgrade
  echo -e "\n"
}

installCorrettoJdk() {
  if test -f /usr/bin/java; then
    printAlreadyInstalled "java"
    return
  fi

  wget -O- https://apt.corretto.aws/corretto.key | sudo apt-key add - || exit
  sudo add-apt-repository 'deb https://apt.corretto.aws stable main' || exit
  sudo apt-get update
  sudo apt-get install -y java-17-amazon-corretto-jdk || exit
}

installMaven() {
  if [[ -z "${MAVEN_VERSION}" ]]; then
    echo "MAVEN_VERSION environment variable is not set"
    exit
  fi

  if test -d /opt/apache-maven-"$MAVEN_VERSION"; then
    printAlreadyInstalled "maven"
    return
  fi

  wget https://dlcdn.apache.org/maven/maven-3/"$MAVEN_VERSION"/binaries/apache-maven-"$MAVEN_VERSION"-bin.tar.gz || exit
  sudo tar -xvf apache-maven-"$MAVEN_VERSION"-bin.tar.gz || exit
  sudo mv apache-maven-"$MAVEN_VERSION" /opt
  rm apache-maven-"$MAVEN_VERSION"-bin.tar.gz
}

installGo() {
  if test -d /usr/local/go; then
    printAlreadyInstalled "go"
    return
  fi

  wget https://go.dev/dl/go1.21.3.linux-amd64.tar.gz
  sudo tar -C /usr/local -xzf go1.21.3.linux-amd64.tar.gz
  export PATH=$PATH:/usr/local/go/bin
  rm go1.21.3.linux-amd64.tar.gz
}

installAwsCli() {
  if test -f /usr/bin/aws; then
    printAlreadyInstalled "aws"
    return
  fi

  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" || exit
  unzip awscliv2.zip
  sudo ./aws/install || exit
  sudo cp /usr/local/bin/aws /usr/bin/aws
  rm awscliv2.zip
}

installAwsSamCli() {
  if test -f /usr/bin/sam; then
    printAlreadyInstalled "sam"
    return
  fi

  wget https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip || exit
  unzip aws-sam-cli-linux-x86_64.zip -d sam-installation
  sudo ./sam-installation/install || exit
  sudo cp /usr/local/bin/sam /usr/bin/sam
  rm aws-sam-cli-linux-x86_64.zip
}

installKubectl() {
  if test -f /usr/bin/kubectl; then
    printAlreadyInstalled "kubectl"
    return
  fi

  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" || exit
  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl || exit
  sudo cp /usr/local/bin/kubectl /usr/bin/kubectl
}

installKrew() {
  if test -d "$HOME/.krew"; then
    printAlreadyInstalled "krew"
    return
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

  reloadBashrc
  forceRestart "kubectl krew"
}

installKubectx() {
  if test -f /usr/bin/kubectx; then
    printAlreadyInstalled "kubectx"
    return
  fi

  kubectl krew install ctx || exit
  kubectl krew install ns || exit

  touch kubectx
  chmod +x kubectx
  echo '#!/bin/bash' >> kubectx
  echo "kubectl ctx \$@" >> kubectx
  sudo mv kubectx /usr/bin/
  sudo cp /usr/bin/kubectx /usr/local/bin
}

installHomebrew() {
  if test -f /home/linuxbrew/.linuxbrew/bin/brew; then
    printAlreadyInstalled "brew"
    return
  fi

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || exit
  forceRestart "homebrew"
}

installNvm() {
  if test -d "$HOME/.nvm"; then
    printAlreadyInstalled "nvm"
    return
  fi

  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash || exit
  reloadBashrc
}

installK9s() {
  if test -f /home/linuxbrew/.linuxbrew/bin/k9s; then
    printAlreadyInstalled "k9s"
    return
  fi

  brew install derailed/k9s/k9s || exit
}

installNode() {
  export NVM_DIR=$HOME/.nvm;
  source $NVM_DIR/nvm.sh;
  nvm install node || exit
}

installNeoVim() {
  if test -f /usr/bin/nvim; then
    printAlreadyInstalled "nvim"
    return
  fi

  sudo add-apt-repository ppa:neovim-ppa/unstable || exit
  sudo apt update
  sudo apt install neovim || exit
  git clone https://github.com/nvim-lua/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim || exit
}

installBat() {
  if test -f /usr/bin/bat; then
    printAlreadyInstalled "bat"
    return
  fi

  sudo apt install bat || exit
  sudo ln -s /usr/bin/batcat /usr/bin/bat
  brew install bat-extras || exit
}

installWslu() {
  if test -f /usr/bin/wslview; then
    printAlreadyInstalled "WSL Utilities"
    return
  fi

  sudo add-apt-repository -y ppa:wslutilities/wslu
  sudo apt update
  sudo apt install -y wslu
}

installQ() {
  if test -f /usr/bin/q; then
    printAlreadyInstalled "q"
    return
  fi

  wget https://github.com/harelba/q/releases/download/v3.1.6/q-text-as-data-3.1.6-1.x86_64.deb || exit
  sudo dpkg -i q-text-as-data-3.1.6-1.x86_64.deb || exit
  rm q-text-as-data-3.1.6-1.x86_64.deb
}

installNode() {
  nvm install node || exit
}