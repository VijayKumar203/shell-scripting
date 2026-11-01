#!/bin/bash

read -p "Enter a number: " n

if [ $n -le 1 ]; then
    echo "Enter a number greater than 1"
else
    flag=0
    for ((i=2; i<=n/2; i++))
    do
        if [ $((n%i)) -eq 0 ]; then
            flag=1
            break
        fi
    done

    if [ $flag -eq 0 ]; then
        echo "$n is a prime number"
    else
        echo "$n is not a prime number"
    fi
fi
