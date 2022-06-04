#!/bin/bash

grep 'ACC' /etc/passwd | awk -F ":" '{print $5}' | cut -d ',' -f 2 | sort | uniq > branches.txt

echo | awk '{print "CEO:CEO::::/home/CEO:/bin/bash"}' | sudo newusers 

for branch in $(cat branches.txt)
do 
	grep "$branch" /etc/passwd | cut -d: -f1 > accounts.txt
	number=$(echo $branch | cut -dh -f2)
	for account in $(cat accounts.txt)
	do	
		sudo setfacl -m u:CEO:r "/home/$account/Current_Balance.txt"
		sudo setfacl -m u:CEO:r "/home/$account/Transaction_History.txt"
		groupadd "M$account"
		sudo chown :"M$account" "/home/$account/Current_Balance.txt"
		sudo chown :"M$account" "/home/$account/Transaction_History.txt"
		sudo chmod 760 "/home/$account/Current_Balance.txt"
		sudo chmod 760 "/home/$account/Transaction_History.txt"
		sudo usermod -a -G "M$account" "MANAGER$number"
		sudo setfacl -m g:$account:r "/home/$account/Current_Balance.txt"
		sudo setfacl -m g:$account:r "/home/$account/Transaction_History.txt"
		sudo setfacl -m o::--- "/home/$account/Current_Balance.txt"
		sudo setfacl -m o::--- "/home/$account/Transaction_History.txt"
		sudo setfacl -m o::rwx "/home/$account"
		sudo setfacl -m mask::rw "/home/$account/Current_Balance.txt"
		sudo setfacl -m mask::rw "/home/$account/Transaction_History.txt"
		sudo setfacl -m u:CEO:r "/home/MANAGER$number"
		sudo setfacl -m o::--- "/home/MANAGER$number"
	done
done
rm branches.txt
rm accounts.txt
