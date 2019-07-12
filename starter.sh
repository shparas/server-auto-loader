#!/bin/bash

sudo node app.js &
app=$!
sleep 3

while [ 1 ]; do
	status=`git remote update`
	status=`git status -uno | sed -n '2p' | cut -c 16-20`
	if [ "$status" != "up to" ]; then
		sudo kill -0 $app
		fg
		echo;echo "Updating the server files"
		git fetch --all
		git reset --hard origin/master
		sudo node app.js &
		app=$!
	else
		echo -n .
	fi
	sleep 5
done
