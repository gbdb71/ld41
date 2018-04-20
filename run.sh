#!/bin/sh

clear
./clean.sh all
echo ""
./compile.sh

if [ "$?" -eq "0" ]; then
    echo ""
    echo "Running with Löve <3"
    love ./lua
fi
