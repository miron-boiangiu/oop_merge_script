#!/bin/bash
: '
    Made by: Boiangiu Victor-Miron

    This is a simple bash script for combining all .java source files from a 
    directory and subdirectories into a single file.
'

shopt -s globstar

function parse_line(){
    file_name=$1
    line="$2"
    shift 2
    if [[ "$line" =~ ^import\ .*$ ]]; then
        echo "$line" >> imports.temp
    elif ! [[ "$line" =~ ^package\ .*$ ]]; then
        echo "$line" >> code.temp
    fi
}

function parse_single_script_file(){
    file_name=$1
    shift 1

    while IFS= read -r line || [ -n "$line" ]; do
        parse_line $file_name "$line"
    done < "$file_name"
    echo -e "\n" >> code.temp  # A newline a day keeps the doctor away.
}

function create_empty_necessary_files(){
    (rm single_script.java 2> /dev/null) 
    touch imports.temp
    touch code.temp
    touch single_script.java
}

function cleanup(){
    (rm imports.temp code.temp 2> /dev/null) 
}

function parse_all_script_files(){
    for file in **/*; do  # Note: if this fails, you don't have Bash >= 4.0
        if [[ "$file" =~ ^.*\.java$ ]] && [ "$file" != "single_script.java" ]; then

            echo "Parsing: $file"
            parse_single_script_file "$file"

        fi
    done
    echo ""
}

function compute_package_name(){
    #  TODO: comment this pos
    file_to_consider=""
    file_package=""
    my_path="$(pwd)"
    file_path=""
    number_of_deletions=0

    for file in **/*; do  # Note: if this fails, you don't have Bash >= 4.0
        if [[ "$file" =~ ^.*\.java$ ]] && [ "$file" != "single_script.java" ]; then
            file_to_consider="$file"
            break
        fi
    done

    file_package="$(cat $file_to_consider | grep package | cut -d " " -f2)"
    file_package=${file_package::-1} 
    file_path="$(realpath $file_to_consider)"
    file_path=${file_path%/*}

    if [[ $file_path == $my_path ]]; then
        echo "$file_package"
    else
        my_path_wc=$(echo $my_path | tr "/" " " | wc -w)
        file_path_wc=$(echo $file_path | tr "/" " " | wc -w)
        number_of_deletions=$(($file_path_wc - $my_path_wc))        
        file_package=${file_package/.//}
        for ((i = 0 ; i < $number_of_deletions ; i++)); do
            file_package=${file_package%/*}
        done
        file_package=${file_package///.}
        echo "$file_package"
    fi
}

function create_single_script(){
    package=""

    echo -e "\nCreating necessary files.\n"
    create_empty_necessary_files

    echo -e "Will go through all source files.\n"
    parse_all_script_files

    echo -e "Computing new package name.";
    package=$(compute_package_name)
    
    echo -e "New package name seems to be \"$package\".\n"
    echo -e "package $package;\n" >> single_script.java

    echo -e "Deleting temporary files.\n"
    cleanup

    echo -e "Done! :)\n"
}

# Entry point:
create_single_script
