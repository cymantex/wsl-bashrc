#########################
# Git
#########################
function getMasterBranchName() {
  if [[ $(git branch | grep "main") != "" ]]; then
    echo "main"
  else
    echo "master"
  fi
}

function gitRemoveBranchByRegex() {
  git branch | grep $1 | xargs git branch -D
}

# Pull / Push / Commit
function gitStashPull() {
  git add .
  git stash save
  git pull --rebase

  if [[ $? == 0 ]]; then
    git stash pop
  fi
}

function gitAmend() {
  git add .
  git commit --amend --no-edit
}

function gitPush() {
  git pull "$@"

  if [[ $? == 0 ]]; then
    git push
  fi
}

function gitAmendPush() {
  gitAmend && gitPush "$@"
}

# Other
function gitRemoveAllChanges() {
	git restore --staged .
	git checkout .
	git clean -f .
}
