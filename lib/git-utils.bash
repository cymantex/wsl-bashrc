#########################
# Git
#########################
getMasterBranchName() {
  if [[ $(git branch | grep "main") != "" ]]; then
    echo "main"
  else
    echo "master"
  fi
}

gitRemoveBranchByRegex() {
  git branch | grep $1 | xargs git branch -D
}

# Pull / Push / Commit
gitStashPull() {
  git add .
  git stash save

  if git pull "$@"; then
    git stash pop
  fi
}

gitSync() {
  git add .
  git commit -m "$1" --no-verify
  git pull --rebase
  git push
}

gitAmend() {
  git add .
  git commit --amend --no-edit "$@"
}

gitCommit() {
  git add .
  git commit -m "$@"
}

gitPush() {
  if git pull "$@"; then
    git push
  fi
}

gitAmendPush() {
  gitAmend "$@" && gitPush --rebase
}

# Other
gitRemoveAllChanges() {
	git restore --staged .
	git checkout .
	git clean -f .
}

gitUpdateWslBashrc() {
  originalPwd=$(pwd)
  cd "$WSL_BASHRC" || return
  gitStashPull --rebase
  cd "$originalPwd" || return
  reloadBashrc
}