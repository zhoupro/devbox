#!/bin/bash

# auto connect your paired bluetooth devices

while true
do
    sleep 5
    bluetoothctl devices | cut -f2 -d ' '| while read -r uuid
    do
        info=`bluetoothctl info $uuid`
        if echo $info | grep -q "Connected: no"; then
            echo "connect $uuid"
            bluetoothctl --timeout 3 connect $uuid
        fi
    done
done
