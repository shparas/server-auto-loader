#!/bin/bash

# If Git requires username and password, will prompt in the middle.
# Our main process runs in background.
sudo node app.js &

# Copy that process ID into app variable.
app=$!

# Not required but lets wait for few seconds.
sleep 3

# Forever Loop
while [ 1 ]; do
	# Check if files are updated on the remote origin.
	status=`git remote update`
	status=`git status -uno | sed -n '2p' | cut -c 16-20`
	if [ "$status" != "up to" ]; then
		# If updated then kill our process, fetch the files
		# and run the process again as before.
		sudo kill -0 $app
		# Lets give some time for the process to die.
		sleep 5
		echo; echo "Updating the server files"
		git fetch --all
		git reset --hard origin/master
		sudo node app.js &
		app=$!
	else
		# If not updated then just print a '.'.
		echo -n .
	fi
	# Lets pause again so that we do not overload the server.
	sleep 5
done
