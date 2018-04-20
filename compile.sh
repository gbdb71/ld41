#!/bin/sh

if [ -n "$1" ] && [ "$1" = "check" ]; then
    clear
    echo "Checking MoonScript files..."
    moonc -l src/.
else
    clear
    echo "Compiling MoonScript files..."
    moonc -t "lua/" src/.
fi

if [ "$?" -eq "0" ]; then
    echo "Done!"
fi
