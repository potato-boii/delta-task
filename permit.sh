#!/bin/bash

grep 'ACC' /etc/passwd | awk -F ":" '{print $5}' | cut -d ',' -f 2 | sort | uniq > branches.txt

echo | awk '{print "CEO:CEO::::/home/CEO:/bin/bash"}' | newusers 

for branch in $(cat branches.txt)
do 
	grep "$branch" /etc/passwd | cut -d: -f1 > accounts.txt
	number=$(echo $branch | cut -dh -f2)
	for account in $(cat accounts.txt)
	do	
		setfacl -m u:CEO:r "/home/$account/Current_Balance.txt"
		setfacl -m u:CEO:r "/home/$account/Transaction_History.txt"
		groupadd "M$account"
		chown :"M$account" "/home/$account/Current_Balance.txt"
		chown :"M$account" "/home/$account/Transaction_History.txt"
		chmod 760 "/home/$account/Current_Balance.txt"
		chmod 760 "/home/$account/Transaction_History.txt"
		usermod -a -G "M$account" "MANAGER$number"
		setfacl -m g:$account:r "/home/$account/Current_Balance.txt"
		setfacl -m g:$account:r "/home/$account/Transaction_History.txt"
		setfacl -m g:$Maccount:rw "/home/$account/Current_Balance.txt"
		setfacl -m g:$Maccount:rw "/home/$account/Transaction_History.txt"
		setfacl -m o::--- "/home/$account/Current_Balance.txt"
		setfacl -m o::--- "/home/$account/Transaction_History.txt"
		setfacl -m o::rwx "/home/$account"
		setfacl -m mask::rw "/home/$account/Current_Balance.txt"
		setfacl -m mask::rw "/home/$account/Transaction_History.txt"
		setfacl -m u:CEO:r "/home/MANAGER$number"
		setfacl -m o::--- "/home/MANAGER$number"
	done
done
rm branches.txt
rm accounts.txt
