#!/bin/sh

cleanningsExecuted=0

luaFiles=$(./listFiles.sh lua)

if [ -n "$luaFiles" ]; then
    echo "Cleanning .lua files from /lua..."
    rm -f $luaFiles
    cleanningsExecuted=$(( cleanningsExecuted + 1 ))
else
    echo "Folder /lua is already cleared"
fi

binFiles=$(./listFiles.sh bin)

if [ -n "$binFiles" ]; then
    echo "Cleanning bin files from /bin..."
    rm -f $binFiles
    cleanningsExecuted=$(( cleanningsExecuted + 1 ))
else
    echo "Folder /bin is already cleared"
fi

if [ "$cleanningsExecuted" -gt "0" ]; then
    echo "Done!"
fi
