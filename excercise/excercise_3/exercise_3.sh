if [ -d "$1" ]; then
    ls $1
else
    echo "Folder not found"
fi
