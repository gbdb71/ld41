#!/bin/sh

if [ -n "$1" ] && [ "$1" = "check" ]; then
    echo "Checking MoonScript files..."
    moonc -l src/.
else
    echo "Compiling MoonScript files..."
    moonc -t "lua/" src/.
fi

if [ "$?" -eq "0" ]; then
    echo "Done!"
    exit 0
fi

exit 1
