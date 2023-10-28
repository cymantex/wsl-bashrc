PS1='${debian_chroot:+($debian_chroot)}\[\033[01;34m\]\W\[\033[00m\]\$ '

# Set the Windows Terminal title to the path
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;\w\a\]$PS1"
    ;;
*)
    ;;
esac