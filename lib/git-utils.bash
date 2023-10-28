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

gitAmend() {
  git add .
  git commit --amend --no-edit
}

gitPush() {
  if git pull "$@"; then
    git push
  fi
}

gitAmendPush() {
  gitAmend && gitPush "$@"
}

# Other
gitRemoveAllChanges() {
	git restore --staged .
	git checkout .
	git clean -f .
}
