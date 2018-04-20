#!/bin/sh

clearLuaFiles() {
    luaFiles=$(./listFiles.sh lua)

    if [ -n "$luaFiles" ]; then
        echo "Cleanning .lua files from /lua..."
        rm -f $luaFiles
        return $?
    else
        echo "Folder /lua is already cleared"
    fi

    return 1
}

clearBinFiles() {
    binFiles=$(./listFiles.sh bin)

    if [ -n "$binFiles" ]; then
        echo "Cleanning bin files from /bin..."
        rm -f $binFiles
        return $?
    else
        echo "Folder /bin is already cleared"
    fi

    return 1
}

cleanningsExecuted=0

if [ -n "$1" ] && [ "$1" = "lua" ]; then
    clearLuaFiles
    if [ "$?" -eq "0" ]; then
        cleanningsExecuted=$(( cleanningsExecuted + 1 ))
    fi
elif [ -n "$1" ] && [ "$1" = "bin" ]; then
    clearBinFiles
    if [ "$?" -eq "0" ]; then
        cleanningsExecuted=$(( cleanningsExecuted + 1 ))
    fi
elif [ -n "$1" ] && [ "$1" = "all" ]; then
    clearLuaFiles
    if [ "$?" -eq "0" ]; then
        cleanningsExecuted=$(( cleanningsExecuted + 1 ))
    fi

    clearBinFiles
    if [ "$?" -eq "0" ]; then
        cleanningsExecuted=$(( cleanningsExecuted + 1 ))
    fi
fi

if [ "$cleanningsExecuted" -gt "0" ]; then
    echo "Done!"
fi
