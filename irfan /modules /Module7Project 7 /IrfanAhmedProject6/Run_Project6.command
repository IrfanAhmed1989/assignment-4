#!/bin/bash
# Double-click launcher for Project 6 (kept in the same folder)
# It always runs the script that sits next to this .command file.
cd "$(dirname "$0")"
./CSC6303_Project6_IrfanAhmed.sh
read -n 1 -p "Press any key to close..."
