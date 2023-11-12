############################
## Environment variables
############################

if [ -z "$WIN_USER" ]; then
  # Initialize WIN_USER for WSL1
  WIN_USER=$(powershell.exe '$env:UserName' | tr -d '\r')
  export WIN_USER
fi

# Windows paths from WSL
export WIN_ROOT="/mnt/c"
export WIN_HOME="$WIN_ROOT/Users/$WIN_USER"
export WIN_PROGRAM_FILES="$WIN_ROOT/Program Files"
export WIN_APPDATA="$WIN_HOME/AppData"
export WIN_ROAMING="$APPDATA/Roaming"
