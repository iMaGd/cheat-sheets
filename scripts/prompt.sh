#!/usr/bin/env bash

function choose_from_list_menu() {
    local -r prompt="$1" outvar="$2" outval="$3"
    # Skip the first 3 arguments and process the rest as key-value pairs
    shift 3

    # Create arrays for display text and values
    local display_texts=() values=()

    # Process arguments as key-value pairs
    while (( $# > 0 )); do
        display_texts+=("$1")
        values+=("$2")
        shift 2
    done

    local cur=0 count=${#display_texts[@]} index=0
    local esc=$(echo -en "\e") # cache ESC as test doesn't allow esc codes
    printf "$prompt\n"
    while true
    do
        # list all options
        index=0
        for o in "${display_texts[@]}"
        do
            if [ "$index" == "$cur" ]
            then echo -e "> \e[42m$o\e[0m" # mark & highlight the current option
            else echo "  $o"
            fi
            (( ++index ))
        done
        read -s -n3 key # wait for user to key in arrows or ENTER
        if [[ $key == $esc[A ]] # up arrow
        then (( cur-- )); (( cur < 0 )) && (( cur = 0 ))
        elif [[ $key == $esc[B ]] # down arrow
        then (( ++cur )); (( cur >= count )) && (( cur = count - 1 ))
        elif [[ $key == "" ]]
        then break
        fi
        echo -en "\e[${count}A" # go up to the beginning to re-render
    done

    # export the selection to the requested output variables
    printf -v $outvar "${display_texts[$cur]}"
    printf -v $outval "${values[$cur]}"
}

# Example usage with key-value pairs
# selections_display=(
#     "Selection 1" "value_a"
#     "Selection 2" "value_b"
#     "Selection 3" "value_c"
# )

# choose_from_list_menu "Please make a choice:\n" selected_display selected_value "${selections_display[@]}"
# echo -e "\nConnecting to : $selected_display .. "
# echo "Selected value: $selected_value"
