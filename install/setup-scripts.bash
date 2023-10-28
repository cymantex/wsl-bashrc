setupWinSymbolicLinks() {
  ln -s "$WIN_HOME"/.testcontainers.properties ~/.testcontainers.properties
  ln -s "$WIN_HOME"/.aws ~
  ln -s "$WIN_HOME"/.kube ~
  ln -s "$WIN_HOME"/.config ~
  ln -s "$WIN_HOME"/.git-templates ~
  ln -s "$WIN_HOME"/.m2 ~
}

setupWinSsh() {
  cp -r "$WIN_HOME"/.ssh ~
  chmod 600 ~/.ssh/id_rsa
}

setupGlobalGitConfig() {
  echo "email: "
  read -r email
  git config --global user.email "$email"

  echo "name: "
  read -r name
  git config --global user.name "$name"

  git config --global core.editor nvim
  git config --global init.defaultbranch main
  git config --global push.autosetupremote true

  echo -e "\nGit config is now setup with the following:"
  git config --global --list
}