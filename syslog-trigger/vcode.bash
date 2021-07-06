#!/usr/bin/env bash
while read line ; do
    ( cd /path/to/script ; ./vcode.php $line )
    done < "${1:-/dev/stdin}"
