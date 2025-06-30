#!/bin/bash

# Script to type out contents of the clipboard. This is useful when working with
# applications like Guacamole that may not support direct pastes.
# Source: https://gist.github.com/skarllot/6e09503f7632c30e9ce34c25b6392824

# Help/Usage function
show_help() {
 echo "Usage: $0 [options]"
 echo "Types out the contents of the clipboard into a selected window."
 echo ""
 echo "Options:"
 echo " -h, --help Show this help message and exit."
 echo ""
 echo "Dependencies:"
 echo " - xclip: Utility to access the X clipboard."
 echo " - xdotool: Utility to simulate keyboard input and window management."
 echo ""
 echo "If dependencies are missing, the script will prompt to install them."
 exit 0
}

# Check if help is requested
if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
 show_help
fi

# Function to check if a command is installed
check_dependency() {
 local cmd="$1"
 local package="$2"
 if ! command -v "$cmd" &> /dev/null; then
 echo "Error: '$cmd' is not installed."
 read -p "Would you like to install '$package' now? (y/n): " answer
 if [[ "$answer" == [Yy] ]]; then
 echo "Installing '$package'..."
 sudo apt update && sudo apt install -y "$package"
 if ! command -v "$cmd" &> /dev/null; then
 echo "Error: Installation of '$package' failed. Please install it manually."
 exit 1
 else
 echo "'$package' installed successfully."
 fi
 else
 echo "Error: '$cmd' is required to run this script. Please install it manually."
 exit 1
 fi
 fi
}

# Check for required dependencies
check_dependency "xclip" "xclip"
check_dependency "xdotool" "xdotool"

# Main script functionality: Type out clipboard contents
xclip -selection clipboard -out \
| tr \\n \\r \
| xdotool selectwindow windowfocus type --clearmodifiers --delay 25 --window %@ --file -