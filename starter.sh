#!/bin/bash

sudo node app.js &
app=$!
sleep 3

while [ 1 ]; do
	status=`git status -uno | sed -n '2p' | cut -c 16-20`
	if [ "$status" != "up to" ]; then
		sudo kill -0 $app; 
		git pull
		sudo node app.js &
		app=$!
		sleep 3
	else
		echo "Up to date"
		sleep 5
	fi
done
