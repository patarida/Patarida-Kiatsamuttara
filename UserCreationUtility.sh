#!/bin/bash

# This program is a utiltiy for creating new users. The program will
# 1. Read the csv file that contains users first name, last name and department.
# 2. For each line: 
# 2.1 check if the user exists:
# 2.1.1 if the user does not exist, create a username.
# 2.1.2 if the user already exists, show an error to the program user and continue to the next user.
# 2.2 check if the department exists:
# 2.2.1 if the department  does not exist, create a department.
# 2.2.2 if the department  already exists, show an error and continue to the next user.
# 2.3. Make the users primary group their department group.
# 4. Once every user is checked, output the final message to the user: how many new users were added + how many new groups are added.



# 1. Read the csv file that contains users first name, last name and department.
# Remove all cariage return and line feed from the csv file.
sed 's/\r$//' EmployeeNames.csv > out.txt
sed 1d out.txt | while IFS=, read -r firstname lastname department
do 
  # 2.1 check if the user exists:
  	user=${firstname:0:1}${lastname:0:7}
	if [ -f ./UserList ]
	then
		if  grep -q $user ./UserList
		then
			# 2.1.2 if the user already exists, show an error
			echo "User already exists!"
		else
			# 2.1.1 if the user does not exist, create a username.
			echo "$user $department" >> ./UserList
			sudo useradd $user
		fi
	else
		echo "$user $department" > ./UserList
		sudo useradd $user
  	fi

  # 2.2 check if the department exists:
  	if [ -f ./DepartmentList ]
	then
		if  grep -q $department ./DepartmentList 
		then
			# 2.2.2 if the department  already exists, show an error
			echo "Department already exists!"
		else
			# 2.2.1 if the department  does not exist, create a department.
			echo "$department" >> ./DepartmentList 
			sudo groupadd $department
		fi
	else
		echo "$department" > ./DepartmentList 
		sudo groupadd $department
  	fi
  # 2.3. Make the users primary group their department group.
  sudo usermod -g $department $user
done


# 4. Once every user is checked, output the final message to the user: how many new users were added + how many new groups are added.
echo The program is finished.
echo There are total $(wc -l UserList | grep -o -E [0-9]+) users and $(wc -l DepartmentList | grep -o -E [0-9]+) departments added.


