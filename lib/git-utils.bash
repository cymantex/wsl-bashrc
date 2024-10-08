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
  message="$1"
  shift

  git add .
  git commit -m "$message" "$@"
  gitPush --rebase
}

gitSyncAmend() {
  gitAmend "$@"
  gitPush --rebase
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

gitCloneAllGithubReposForUser() {
  user="$1"

  if [[ -z "$user" ]]; then
    echo "Usage: gitCloneAllGithubReposForUser <user>"
    return
  fi

  gh repo list --limit 1000 | while read -r repo _; do
    if [[ -d "$repo" ]]; then
      echo "$repo already exists. Skipping..."
      continue
    fi

    gh repo clone "$repo" "$repo"
  done
}