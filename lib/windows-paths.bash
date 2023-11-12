############################
## Environment variables
############################

if [ -z "$WIN_USER" ]; then
  echo "WIN_USER is not set. Exiting..."
  exit 1
fi

# Windows paths from WSL
export WIN_ROOT="/mnt/c"
export WIN_HOME="$WIN_ROOT/Users/$WIN_USER"
export WIN_PROGRAM_FILES="$WIN_ROOT/Program Files"
export WIN_APPDATA="$WIN_HOME/AppData"
export WIN_ROAMING="$APPDATA/Roaming"
