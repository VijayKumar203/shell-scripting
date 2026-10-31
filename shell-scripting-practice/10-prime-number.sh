#!/bin/bash

read -p "Enter a number: " n

if [ $n -le 1 ]; then
    echo "$n Enter a number greater than 1"
else
    flag=0
    for ((i=2; i<=n; i++))
    do
        for ((j=2; j<=i/2; j++))
        do
            if [ $((n%j)) -eq 0 ]; then
                flag=1
                break
            fi
        done
        if [ $flag -eq 0 ]; then
        echo "$i, "
        flag=0
        fi
    done
fi
