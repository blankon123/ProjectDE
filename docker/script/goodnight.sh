#!/bin/bash
if [[$(docker ps --filter name=_tgs -aq)]]; then
    echo 'Stopping Container...'
    docker ps --filter name=*_tgs -aq | xargs docker stop
    echo 'All Container Stopped...'
    echo 'Removing Container...'
    docker ps --filter name=*_tgs -aq | xargs docker rm
else
    echo "All Cleaned UP!"
fi