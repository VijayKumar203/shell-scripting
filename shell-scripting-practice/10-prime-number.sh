#!/bin/bash

read -p "Enter a number: " n

if [ $n -le 1 ]; then
    echo "Enter a number greater than 1"
else
    flag=0
    count=0
    for ((i=2; i<=n; i++))
    do
        for ((j=2; j<=i/2; j++))
        do
            if [ $((i%j)) -eq 0 ]; then
                flag=1
                break
            fi
        done
        if [ $flag -eq 0 ]; then
            echo -n "$i "
            count=$(($count+1))
        fi
        flag=0
    done
    echo ""
    echo "Total Prime Numbers: $count"
fi
