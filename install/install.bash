. ../lib/cli-tools.bash
. install-scripts.bash

cd ~ || exit

disableStartUpMessages

updateApt

printTitle "Installing/updating apt packages"
sudo apt install -y software-properties-common lsb-release build-essential procps curl file git
sudo apt install -y unzip zip dnf jq bat dos2unix libtool autoconf cmake libxml2-utils fzf ripgrep
sudo apt install -y fd-find
echo -e "\n"

printTitle "Installing package managers"
installNvm
installHomebrew
echo -e "\n"

printTitle "Installing DevTools"
installBat
installQ
installNeoVim
installWslu
installNode
installMaven
installCorrettoJdk
installGo
installTldr
echo -e "\n"

printTitle "Installing AWS tools"
installAwsCli
installAwsSamCli
echo -e "\n"

printTitle "Installing Kubernetes tools"
installKubectl
installKrew
installKubectx
installK9s
echo -e "\n"

printTitle "Verifying installs"
verifyCliToolInstalls
echo -e "\n"

printCliLinks