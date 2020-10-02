#!/bin/bash

your_roll=1605106
g++ -D CYCLIST_COUNT=10 -D SERVICE_ROOM_COUNT=3 -D PAYMENT_ROOM_CAPACITY=2 -D SCRIPTED checker_Redwan.cpp -o checker_Redwan
g++ -D _REENTRANT $your_roll.cpp -o $your_roll -lpthread -O2 || exit

echo checking potential deadlocks and race conditions
g++ -D _REENTRANT $your_roll.cpp -o ${your_roll}_sanitized -lpthread -O2 -fsanitize=thread -g
TSAN_OPTIONS=second_deadlock_stack=1 ./${your_roll}_sanitized >/dev/null
rm ${your_roll}_sanitized
echo checking potential deadlocks and race conditions done

echo ==================
echo testing begins
echo ==================

for((i=1;;++i)); do
    printf '\ntest %d\n' "$i"
    time ./$your_roll > $your_roll.txt
    ./checker_Redwan < $your_roll.txt || break
done

rm $your_roll

exit
