#!/bin/sh

ipk_folder=/data/ipk      # Put all .ipk files there, by "adb push"
tmp_folder=/data/tmp      # There is regular OpenWrt file structure after
                          # unpacking ipk files, like this:
                          # ./etc
                          # ./lib
                          # ./sbin
                          # ./usr
                          # ./www

# How to use #
##############
# Once the .ipk files in the place, just run the script: opkg.sh
################################################################

###########
# HELPERS #
###########

# This helper function checks whether the target file/folder is already exist. If not,
# then the folder is created and file or symlink is copied to the regular OpenWrt
# folder structure, like /usr/lib, /usr/bin, /etc/init.d, etc.
populate_file(){
    local source="${1}"
    local target="${2}"

    # Skip that files, which name ends with ".js.o"
    [[ ${source:0-5} == ".js.o" ]] && { echo "SKIP: $source "; return 0; }

    # If source is a directory and target location does not exist
    # then create directory in target location
    [[ -d "${source}" ]] && [[ ! -s "${target}" ]] && { mkdir -p "${target}"; return; }

    # If source is a file and target file doesn't exist then copy it to target location
    [[ -f "${source}" ]] && [[ ! -e "$target" ]] && { cp -P "${source}" "${target}"; return; }
}


################
# MAIN PROCESS #
################

# Unpack .ipk files placed in $ipk_folder and put its content to $tmp_folder

cd "$ipk_folder" || return 0
files="$(ls)"
[ -z "$files" ] && return 0

mkdir -p "$tmp_folder" || return 0
for file in $files; do
    tar zxpvf "$ipk_folder/$file" -C "$tmp_folder" 1> /dev/null
    cd "$tmp_folder" && tar -xzf data.tar.gz 1> /dev/null
    rm $tmp_folder/*.gz
    rm $tmp_folder/debian-binary
done

# Populate regular OpenWrt folders with compiled files extracted from .ipk

cd "$tmp_folder"
sources=$(find ./* -maxdepth 10)
for src in $sources; do
    target=${src:1}
    populate_file $src $target
done
