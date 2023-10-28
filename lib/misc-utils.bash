############################
# Miscellaneous utilities
############################
alias reloadBashrc=". ~/.bashrc"

sudoWithLocalBashrc() {
	sudo bash -c 'source /home/'$USER'/.bashrc; '$@''
}

# Clipboard
alias clip='clip.exe'
alias readClipBoard='powershell.exe -command "Get-ClipBoard"'

# Kill processes
alias killJava='killall java'
alias killNode='killall node'

# Allows calling python module using a syntax like _python3 path/to/script.py
_python3() {
  scriptPath=$1
  shift

  # Replace all "/" with "." and remove ".py"
  modulePath=$(echo "$scriptPath" | sed 's#/#.#g' | sed 's/.py//g')

  python3 -m $modulePath $@
}

#########################
# Run .sql on .csv files
# Install & docs: http://harelba.github.io/q/
#########################
runCsvSql() {
  sql_file="$(cat $1)"
  # Parameters which works with the default DBeaver .csv export.
  q -H -O -d , "$sql_file"
}

############################
# DBeaver
############################

# Useful if you want to know the password for a given connection
decryptDbeaverCredentials() {
  if [[ $# -ne 1 ]]; then
    echo "Usage: decryptDbeaverCredentials <project_name>"
    return
  fi

  projectName=$1
  pwd=$PWD
  cd "$WIN_APPDATA/Roaming/DbeaverData/workspace6/$projectName/.dbeaver" || return
  openssl aes-128-cbc -d \
    -K babb4a9f774ab853c96c2d653dfe544a \
    -iv 00000000000000000000000000000000 \
    -in credentials-config.json |
    dd bs=1 skip=16 2>/dev/null
  cd "$pwd" || exit
}

############################
# Create environment variables
############################
createFolderEnvironmentVariables() {
  folder=$1
  prefix=$2

  folderPaths=$(find "$folder" -maxdepth 1 -type d | xargs --null | sed 's/ /%/g')

  for folderPath in $folderPaths; do
    folderName="$(basename "$folderPath")"
    variableName=$(echo "${folderName^^}" | sed 's/-/_/g' | sed 's/ /_/g' | tr -cd '[:alnum:]_')

    # shellcheck disable=SC2001
    folderPathWithSpaces=$(echo "$folderPath" | sed 's/%/ /g')
    export "$prefix$variableName=\"$folderPathWithSpaces\""
  done
}

printFolderEnvironmentVariables() {
  folder=$1
  prefix=$2

  folderPaths=$(find "$folder" -maxdepth 1 -type d | xargs --null | sed 's/ /%/g')

  for folderPath in $folderPaths; do
    folderName="$(basename "$folderPath")"
    variableName=$(echo "${folderName^^}" | sed 's/-/_/g' | sed 's/ /_/g' | tr -cd '[:alnum:]_')

    # shellcheck disable=SC2001
    folderPathWithSpaces=$(echo "$folderPath" | sed 's/%/ /g')
    echo "export $prefix$variableName=\"$folderPathWithSpaces\""
  done
}