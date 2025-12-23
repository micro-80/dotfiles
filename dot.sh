#!/usr/bin/env bash
set -e

HOME_HOSTNAME="frank.local"
# TODO
WORK_HOSTNAME=""

HOME_DIRECTORY="/Users/$(whoami)"
DOTFILE_DIRECTORY="$HOME_DIRECTORY/Code/dotfiles"

COMMON_DIRECTORY="$DOTFILE_DIRECTORY/common"
HOME_HOST_DIRECTORY="$DOTFILE_DIRECTORY/hosts/home"
WORK_HOST_DIRECTORY="$DOTFILE_DIRECTORY/hosts/work"

get_files () {
    local dir="$1"
    find "$dir" -type f
}

replace_dir () {
    sed "s|$1\/*|$2/|"
}

make_directories_in_home() {
    local dir="$1"
    dirname $(get_files "$dir") | uniq | replace_dir "$dir" "$HOME_DIRECTORY" | xargs mkdir -p
}

link_files_to_home () {
    local dir="$1"
    local dotfiles=$(get_files "$dir")
    
    get_files "$dir" | while IFS= read -r file; do
	local home_file=$(echo "$file" | replace_dir "$dir" "$HOME_DIRECTORY")
	ln -sf "$file" "$home_file"
    done
}

command_sync () {
    hostname=$(hostname)
    host_directory="/to/be/filled/in"
    if [[ "$hostname" == "$HOME_HOSTNAME" ]]; then
	host_directory="$HOME_HOST_DIRECTORY"
    elif [[ "$hostname" == "$WORK_HOSTNAME" ]]; then
	host_directory="$WORK_HOST_DIRECTORY"
    else
	echo "Unknown host. Exiting."
	exit 1
    fi
    
    make_directories_in_home "$COMMON_DIRECTORY"
    link_files_to_home "$COMMON_DIRECTORY"

    make_directories_in_home "$host_directory"
    link_files_to_home "$host_directory"
}

command_add () {
    file="$2"
    destination="$3"
    destination_folder="/to/be/filled/in"
    
    if [ -z "${2}" ]; then
	echo "File name argument missing"
	exit 1
    fi

    if [ -L "$file" ]; then
	echo "File is a symlink. Exiting"
	exit 1
    fi

    if [[ "$destination" == "home" ]]; then
	destination_folder="$HOME_HOST_DIRECTORY"
    elif [[ "$destination" == "work" ]]; then
	destination_folder="$WORK_HOST_DIRECTORY"
    else
	destination_folder="$COMMON_DIRECTORY"
    fi

    full_file_path=$(realpath "$file")
    destination=$(echo "$full_file_path" | replace_dir "$HOME_DIRECTORY" "$destination_folder")
    destination_mkdir_path=$(dirname "$destination")
    mkdir -p "$destination_mkdir_path"
    mv "$file" "$destination"
    ln -sf "$destination" "$full_file_path"
}

command_rm () {
    file="$2"
    if [ -L "$file" ]; then
	echo "File is not a symlink. Please make sure you're pointing at a tracked dotfile in the home directory."
	exit 1
    fi

    reference_to_delete=$(readlink "$file")
    rm "$file"
    rm "$reference_to_delete"
    find "$DOTFILE_DIRECTORY" -type d -empty -delete
}

"command_$1" "$@"
