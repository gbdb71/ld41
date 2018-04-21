#!/bin/sh

find=C:\\cmder\\vendor\\git-for-windows\\usr\\bin\\find.exe

if [ -n "$1" ]; then
    if [ "$1" = "lua" ]; then
        $find ./lua -name "*.lnk" -prune -o -path "./content" -prune \( -name "*.lua" -o -path "./lua/*" \) -print
    elif [ "$1" = "bin" ]; then
        echo ""
    fi
fi
