#!/bin/bash
# This program's purpose is to block the interent 
# for all users except IT personnel and local web server.
# 1. Retrieve IT personnel
# 2. For each user in the IT group, create a rule to allow incoming HTTPS packets.
# 3. Add local webserver as an exception.
# 4. Add rules to drop output for other department
# 5. Print a message to the user before the program 
# exits: How many users were granted the internet access 
# ($ users in IT group)


# 1. Retrieve IT personnel
members IT > ITmember
# 2. For each user in the IT group, create a rule to allow incoming HTTPS packets.
#sudo iptables -A OUTPUT -p tcp --dport 443 -m owner --uid-owner <username> -j ACCEPT
for member in $(<ITmember); 
do
  sudo iptables -A OUTPUT -p tcp --dport 443 -m owner --uid-owner $member -j ACCEPT
done

# 3. Add local webserver as an exception.
sudo iptables -A OUTPUT -p tcp --dport 443 -d 192.168.2.3 -j ACCEPT

# 4. Add rules to drop output for other department
sudo iptables -t filter -A OUTPUT -p tcp --dport 80 -j DROP
sudo iptables -t filter -A OUTPUT -p tcp --dport 443 -j DROP

# 5. Print a message to the user before the program 
echo The program is finished.
echo $(cat ITmember | wc -w) users were granted the internet access.
