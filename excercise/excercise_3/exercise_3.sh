if [ -z "$1" ]; then
  echo "value input empty !!"
  exit 1
fi

if [ -d "$1" ]; then
    ls $1
else
    echo "Folder not found"
fi
