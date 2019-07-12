sudo nodemon app.js &
app=$!

status=`git status -uno | sed -n '2p'`

kill -STOP $app
git pull
kill -CONT $app 