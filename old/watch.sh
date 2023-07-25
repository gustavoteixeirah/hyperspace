#!/bin/bash
path="/home/teixeira/code/notes" # Replace this with the path to your git repository. To get path, run pwd in the directory or right click and select properties of the folder
while true
do
	inotifywait --recursive -qq -e attrib,create,delete,modify,delete_self,move,move_self,close_write $path
	cd $path                              &> /dev/null
	git pull                              &> /dev/null
	git add --all                         &> /dev/null
	now=$(date)                           &> /dev/null
	git commit --no-gpg-sign -m "Auto-Commit at : $now"  &> /dev/null	
	git push -u origin main               &> /dev/null

    sleep 3600
    # sleep 60
done


#Use ps aux | grep "watch.sh", 
#find the PID of the script 
#and then killing it using kill PID_of_watch.sh
#
#After that you'll have to run
# ps aux | grep "inotify", 
# find the PID of inotify 
# and then killing it using kill PID_of_inotify

# REFERENCE:
#https://github.com/mujtaba1747/git-autocommit