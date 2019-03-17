#!/bin/bash

# To focus exclusively on the performance of each type of increment
# statement, we should exclude bash performing while loops from the
# performance measure. So, let's time individual scripts that
# increment $i in their own unique way.

# Declare i as an integer for tests 12 and 13.
echo > t12 'declare -i i; i=i+1'
echo > t13 'declare -i i; i+=1'
# Set i for test 14.
echo > t14 'i=0; i=$(expr $i + 1)'

x=100000
while ((x--)); do
    echo >> public/t0 'i=$((i+1))'
    echo >> public/t1 'i=$((i++))'
    echo >> public/t2 '((i=i+1))'
    echo >> public/t3 '((i+=1))'
    echo >> public/t4 '((i++))'
    echo >> public/t5 '((++i))'
    echo >> public/t6 'let "i=i+1"'
    echo >> public/t7 'let "i+=1"'
    echo >> public/t8 'let "i++"'
    echo >> public/t9 'let i=i+1'
    echo >> public/t10 'let i+=1'
    echo >> public/t11 'let i++'
    echo >> public/t12 'i=i+1'
    echo >> public/t13 'i+=1'
    echo >> public/t14 'i=$(expr $i + 1)'
done

for script in t0 t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14; do
    line1="$(head -1 "$script")"
    printf "%-24s" "$line1"
    { time bash "$script"; } |& grep user
    # Since stderr is being piped to grep above, this will confirm
    # there are no errors from running the command:
    eval "$line1"
    # rm "$script"
done
