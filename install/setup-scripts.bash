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