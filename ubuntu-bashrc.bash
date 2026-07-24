############################
## System specific
############################
## Edit these to fit your install
############################

# GH_TOKEN is used for all your GitHub repos
# export GH_TOKEN="your-token-here"

# Path to this bashrc repo
export WSL_BASHRC="$HOME/dev/scripts/wsl-bashrc"

# Used by helper scripts to decide whether to enable WSL-only behavior.
export BASHRC_TARGET="ubuntu"

############################
## .bashrc lib imports
############################
. "$WSL_BASHRC/lib-imports.bash"
. "$WSL_BASHRC/external-imports.bash"

# The bashrc included in a fresh Ubuntu install
. "$WSL_BASHRC/external/default-ubuntu.bash"

# Shorten to prompt to only include the current directory
. "$WSL_BASHRC/lib/short-prompt.bash"

