############################
## System specific
############################
## Edit these to fit your install
############################

# Name of your windows user. You can check with $env:UserName in powershell
# export WIN_USER="Simon Eriksson"

# GH_TOKEN is used for all your GitHub repos
# export GH_TOKEN="your-token-here"

# Path to this bashrc repo
export WSL_BASHRC="/mnt/c/dev/scripts/wsl-bashrc"

############################
## .bashrc lib imports
############################
. "$WSL_BASHRC/lib-imports.bash"
. "$WSL_BASHRC/external-imports.bash"

# The bashrc included in a fresh Ubuntu install
. "$WSL_BASHRC/external/default-ubuntu.bash"

# Shorten to prompt to only include the current directory
. "$WSL_BASHRC/lib/short-prompt.bash"