#!/bin/bash
# -------------------------------------------------------------------------------
# This program is for killing the process that slow down the systems.
# 1. Check top 5 processes running by CPU%
# 2. Show the user these 5 processes and ask them to confirm to kill.
# 3. Send SIGKILL signal to any processes except those started by root.
# 4. Log the details.
# 4.1 Log: the username who start the process, when the process started, when the process killed, which department this user works in.
# 4.2 file name: ProcessUsageReport-<CurrentDate> and save to home folder.
# 5. Show the message how many processes were killed. 
# -------------------------------------------------------------------------------

# 1. Check top 5 processes running by CPU%
ps aux --sort -%cpu | head -6 > process
echo This is the top 5 processes currently running on the system by %CPU:
cat process

# 2. Show the user these 5 processes and ask them to confirm to kill.
while true
do
	echo 'Please confirm to kill these processes except for root user (y/n)'
	read confirm
	if [ $confirm == 'y' ]
	then
		echo The killing process is confirmed.
		# top 5 without root inclusive code:
		# ps aux | grep -v ^USER | sort -k10 -r | head -n 6 
		
		# 4. Log the details.

		# 4.1 Log: the username who start the process, when the process started, when the process killed, which department this user works in.
		# obtain process id (pid) in the top 5 processes that are not started by root
		pid=$(cat process | tail -5 | grep -v root | grep -v tty2 | awk '{print $2}')
		echo Process to be killed are $pid
		
		# use the pid to kill the process
		for id in $pid
		do
  			
		
			# log process killed time
			kill_time=$(date +"%a %b %d %T %Y")
		
			# 4.2 file name: ProcessUsageReport-<CurrentDate> and save to home folder.
			Logfile=ProcessUsageReport-$(date +"%Y-%m-%d")
			
			# check if the id still exist in the process or not. If it doesnot exists, skip to the next id.
			# Sometimes, when the previous process is killed, the next process maybe killed together.
			# To prevent an error, the program will skip to the next id if the process id does not exist anymore.
			line=$(ps -p $id | wc -l)
			if [ $line -eq 1 ] 
			then
				continue
			else
			
				# Concatenate all the information needed for logging
				logged_info="$(ps -p $id -o user,lstart,group | tail -1)  $kill_time"
				
				# kill process
				kill -SIGKILL $id 2> /dev/null
				
				# Check if the log file exists. 
				# If it exists, append to the file. If it does not exist, create a new one.
				if [ -f ~/$Logfile ]
				then
					echo $logged_info >> ~/$Logfile
				else
					echo $logged_info > ~/$Logfile
				fi
			fi
		done
		exit

	elif [ $confirm == 'n' ]
	then
		echo The killing process is aborted.
		exit
	else 
		continue
	fi
done

# 5. Show the message how many processes were killed. 
echo The program is finished.
echo $(($(wc -l ~/$Logfile | grep -o -E [0-9]+)-1)) processes are killed.

