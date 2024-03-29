############################
# JSON / XML / Base64
############################
prettifyJson() {
  echo ''$1'' | python3 -m json.tool
}

prettifyJsonFile() {
  cat $1 | python3 -m json.tool
}

prettifyXml() {
  echo "$1" | xmllint --format -
}

prettifyXmlFile() {
  cat $1 | xmllint --format -
}

# Provide a zipped base64 encoded string as argument and this command will print it in clear text
unzipBase64() {
  echo "$1" | base64 -d | gunzip
}

# Same as above but will also format the string if it is JSON or XML
prettyUnzipBase64() {
  UNZIPPED=$(unzipBase64 "$1")

  TYPE=$(echo $UNZIPPED | sed -r '
    :a;$ ! b a
    /^</ {
      s/.*/XML/
      q
    }
    /^\{/ {
      s/.*/JSON/
      q
    }
    /^[^<\{]/ s/.*/NONE/')

  if [ "$TYPE" = "XML" ]; then
    RESULT=$(echo "$UNZIPPED" | xmllint --format - 2>/dev/null)
    if [ "$?" != 0 ]; then
      echo "$UNZIPPED"
    else
      echo "$RESULT"
    fi
  elif [ "$TYPE" = "JSON" ]; then
    RESULT=$(echo "$UNZIPPED" | python -mjson.tool 2>/dev/null)
    if [ "$?" != 0 ]; then
      echo "$UNZIPPED"
    else
      echo "$RESULT"
    fi
  else
    echo "$UNZIPPED"
  fi
}