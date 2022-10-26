#!/bin/bash
: '
    Made by: Boiangiu Victor-Miron

    This is a simple bash script for combining all .java source files from a 
    directory and subdirectories into a single file.

    Usage: run from the root of your project.
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
        echo "$file_package 1"
    else
        my_path_wc=$(echo $my_path | tr "/" " " | wc -w)
        file_path_wc=$(echo $file_path | tr "/" " " | wc -w)
        number_of_deletions=$(($file_path_wc - $my_path_wc))
        package_wc=$(echo $file_package | tr "." " " | wc -w)
        if [[ $package_wc -le number_of_deletions ]]; then
            echo "NO_PACKAGE 0"
        else
            file_package=${file_package//.//}
            for ((i = 0 ; i < $number_of_deletions ; i++)); do
                file_package=${file_package%/*}
            done
            file_package=${file_package////.}
            echo "$file_package 1"
        fi
    fi
}

function interpret_package_name_result(){
    package="$1"
    pkg_determined="$2"
    shift 2
    if [[ $pkg_determined -eq 0 ]]; then
        echo -e "Empty package name or failed to determine it." \
        "Please manually check all imports and the package name.\n"
    else
        echo -e "New package name seems to be \"$package\"\n"
        echo -e "package $package;\n" >> single_script.java
    fi
}

function parse_imports(){
    package="$1"
    pkg_determined="$2"
    shift 2

    sort -u -o imports.temp imports.temp

    if [[ $pkg_determined -eq 0 ]]; then
        while IFS= read -r line || [ -n "$line" ]; do
            echo "$line" >> single_script.java
        done < "imports.temp"
    else

        current_dir="$(pwd)"
        package_wc=$(echo $package | tr "." " " | wc -w)
        project_root_dir="$current_dir"
        for ((i = 0 ; i < $package_wc ; i++)); do
            project_root_dir=${project_root_dir%/*}
        done
        echo "Root of project: $project_root_dir"
        while IFS= read -r line || [ -n "$line" ]; do
            if [ -z "$line" ]; then
                continue
            fi
            import_name=$(echo $line | cut -d " " -f2)
            import_name=${import_name::-1}
            import_location=$(echo $import_name | tr "." "/")
            import_location="$project_root_dir/$import_location.java"
            if ! [ -f "$import_location" ]; then
                echo "$line" >> single_script.java
            else
                echo "Import $import_name found in current project."
            fi
        done < "imports.temp"
        echo -e "" >> single_script.java
    fi
    echo ""
}

function process_classes(){
    # Remove "public" from classes
    while IFS= read -r line || [ -n "$line" ]; do
        if [[ "$line" =~ ^public\ class\ .*\{$ ]]; then
            echo "$line" | sed 's/public //' >> single_script.java
        else
            echo "$line" >> single_script.java
        fi
    done < "code.temp"
    # Search for the class containing the "main" method and make it public.
    lines_containing_main=$(cat single_script.java | grep -n "public static void main")
    main_line_count=$(echo "$lines_containing_main" | wc -l)
    if [[ $main_line_count -eq 1 ]]; then
        main_line=$(echo "$lines_containing_main" | cut -d ":" -f1)
        found_the_main_class=0
        line=""
        while [[ $main_line -ne 1 ]]; do
            ((main_line=main_line-1))
            line=$(sed "${main_line}q;d" single_script.java)
            if [[ "$line" =~ ^class\ .*$ ]]; then
                echo "The main class seems to start at line $main_line."
                break
            fi
        done
        if [[ $main_line -ne 1 ]]; then
            new_line="public $line"
            sed -i "${main_line}s/.*/${new_line}/" single_script.java
        else
            echo "Failed to find the class containing the main function."
        fi

    else
        echo -e "More/less than a single class contain a main function, " \
        "please manually mark the correct one as public."
    fi
    echo ""
    echo -e "\n" >> single_script.java
}

function create_single_script(){
    echo -e "\nCreating necessary files.\n"
    create_empty_necessary_files

    echo -e "Will go through all source files.\n"
    parse_all_script_files

    echo -e "Computing new package name."
    read package pkg_determined < <(compute_package_name)
    interpret_package_name_result $package $pkg_determined

    echo -e "Checking which imports to keep."
    parse_imports $package $pkg_determined

    echo -e "Will now process the classes."
    process_classes

    echo -e "Deleting temporary files.\n"
    cleanup

    echo -e "Done! :)\n"

    echo -e " Note: if you plan on using the resulted file on LambdaChecker,\n"\
    "HackerRank or other such sites, remove \"package [location];\" (the first\n"\
    "line) from it.\n"
}

# Entry point:
create_single_script
