#!/bin/bash

# -------------------------------------------------------
# Category    :: LOADING
# Description :: Displays a rotating animation by shifting the characters in the input string linearly.
#                Useful for indicating progress during background tasks with a smooth terminal effect.
# -------------------------------------------------------
function sdx_linear_loading() {
    local input="$1"
    local repeat=3   
    local delay=0.1   

    export LC_ALL=C.UTF-8

    readarray -t chars < <(echo -n "$input" | grep -o .)
    local len=${#chars[@]}
    local frames=()

    for ((i=0; i<len; i++)); do
        local frame=""
        for ((j=0; j<len; j++)); do
            index=$(( (i + j) % len ))
            frame+="${chars[$index]}"
        done
        frames+=("$frame")
    done

    for ((j=0; j<repeat; j++)); do
        for frame in "${frames[@]}"; do
            echo -ne "\r$frame"
            sleep "$delay"
        done
    done
    echo
    echo 
}

# -------------------------------------------------------
# Category    :: LOADING
# Description :: Shows a "boomerang"-style loading animation by gradually expanding and shrinking
#                the input string. Clears the screen on each frame to enhance the motion effect.
# -------------------------------------------------------
function sdx_boomerang_loading() {
    local input="$1"
    local delay=0.05  
    export LC_ALL=C.UTF-8

    readarray -t chars < <(echo -n "$input" | grep -o .)
    local len=${#chars[@]}
    local frames=()

    for ((i=1; i<=len; i++)); do
        frame=""
        for ((j=0; j<i; j++)); do
            frame+="${chars[$j]}"
        done
        frames+=("$frame")
    done

    for ((i=len-1; i>0; i--)); do
        frame=""
        for ((j=0; j<i; j++)); do
            frame+="${chars[$j]}"
        done
        frames+=("$frame")
    done

    local repeat=3        

    for ((r=0; r<repeat; r++)); do
        for frame in "${frames[@]}"; do
            clear
            echo "$frame"
            # sleep "$delay"
        done
    done
    echo
}
