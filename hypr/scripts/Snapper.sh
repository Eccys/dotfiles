#!/bin/bash

inotifywait -m -e create,delete,move,modify --format '%w%f' /home |
while read file; do
    snapper create -c home -d "Snapshot before change in $file"
done

