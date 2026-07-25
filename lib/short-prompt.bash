# Print " (branch)" when inside a git repository, otherwise nothing
parseGitBranch() {
  git branch 2>/dev/null | sed -n 's/^\* \(.*\)/ (\1)/p'
}

# On ubuntu, append the current git branch (white text) to the prompt
if [ "$BASHRC_TARGET" = "ubuntu" ]; then
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;34m\]\W\[\033[00m\]\[\033[00;37m\]$(parseGitBranch)\[\033[00m\]\$ '
else
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;34m\]\W\[\033[00m\]\$ '
fi

# Set the Windows Terminal title to the path
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;\w\a\]$PS1"
    ;;
*)
    ;;
esac