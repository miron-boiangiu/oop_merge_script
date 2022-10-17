#!/bin/bash
: '
    Made by: Boiangiu Victor-Miron

    This is a simple bash script for combining all .java source files from a 
    directory and subdirectories into a single file.

    TODOs:
    - separate imports and code
    - fix imports
    - keep a single public class
    - keep a single "package" keyword
'

function parse_single_script_file(){
    FILE_NAME=$1
    shift 1

    while IFS= read -r line || [ -n "$line" ]; do
        echo "$line" >> single_script.java
    done < "$FILE_NAME"
    echo -e "\n" >> single_script.java # A newline a day keeps the doctor away.

}

function create_empty_necessary_files(){
    (rm single_script.java 2> /dev/null) 
    touch includes.temp
    touch code.temp
    touch single_script.java
}

function cleanup(){
    (rm includes.temp code.temp 2> /dev/null) 
}

function parse_all_script_files(){
    for FILE in * **/*; do # Note: if this fails, you don't have Bash >= 4.0
        if [[ "$FILE" =~ ".java" ]] && [ "$FILE" != "single_script.java" ]; then

            echo "Looking at: $FILE"
            parse_single_script_file "$FILE"

        fi
    done
}

function create_single_script(){

    echo -e "\nCreating necessary files."
    create_empty_necessary_files

    echo -e "Will go through all source files.\n"
    parse_all_script_files

    echo -e "\nDeleting temporary files."
    cleanup

    echo -e "Done! :)\n"
}

# Entry point:
create_single_script