#!/usr/bin/env bash

# Function to check if git is installed
check_git() {
    if ! command -v git &> /dev/null; then
        echo "Git is not installed or not in the PATH. Please install git and try again."
        exit 1
    fi
}

# Function to ask for directory path with confirmation
ask_directory() {
    local prompt_message="$1"
    local dir_variable="$2"
    
    while true; do
        read -rp "$prompt_message" dir_path
        if [ ! -d "$dir_path" ]; then
            echo "The provided path does not exist. Please try again."
            continue
        fi
        read -rp "You entered '$dir_path'. Is this correct? (y/n) " confirmation
        if [[ "$confirmation" == "y" || "$confirmation" == "Y" ]]; then
            eval "$dir_variable='$dir_path'"
            break
        fi
    done
}

# Function to convert file extensions to lowercase
convert_extensions_to_lowercase() {
    local target_dir="$1"
    echo "Warning: This will recursively rename file extensions to lowercase in the directory '$target_dir'."
    echo "This operation is potentially destructive and cannot be undone."
    read -rp "Are you sure you want to proceed? (y/n) " confirmation
    if [[ "$confirmation" != "y" && "$confirmation" != "Y" ]]; then
        echo "Aborted by user."
        exit 1
    fi
    
    find "$target_dir" -name '*.*' -exec sh -c '
      a=$(echo "$0" | sed -r "s/([^.]*)\$/\L\1/");
      [ "$a" != "$0" ] && mv "$0" "$a" ' {} \;
    
    # Check if the previous command was successful
    if [ $? -eq 0 ]; then
        echo "File extensions converted to lowercase successfully."
    else
        echo "Failed to convert file extensions to lowercase."
        exit 1
    fi
}

# Check if git is installed
check_git

# Ask for patch directory
ask_directory "Enter the path of the directory containing the patch files: " patch_dir

# Ask for game directory
ask_directory "Enter the path of the game directory: " game_dir

# Confirm and convert file extensions to lowercase in the game directory
convert_extensions_to_lowercase "$game_dir"  # Ensure the game_dir is used here

# Enter the game directory
cd "$game_dir" || { echo "Failed to enter game directory. Exiting."; exit 1; }

# Apply the patches
git apply "$patch_dir"/*.diff

echo "Please check readme.txt to see if your game is on the latest version."
