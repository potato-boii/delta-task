!#/bin/bash

if [ $# -eq 0 ] 
   then
	echo "Enter account number(####):"
	read accno
	echo "Enter resident type(citizen,resident,foreigner):"
	read restype
	echo "Enter age group(minor,seniorCitizen,-):"
	read agetype
	echo "Legacy account?(legacy,-):"
	read legacy
	echo | awk -v acc="$accno" '{print "ACC"acc":ACC"acc"::::/home/ACC"acc":/bin/bash"}' > accounts.txt
	newusers accounts.txt
	account=$(cut -d: -f1 accounts.txt | cat)
	sudo touch "/home/$account/Current_Balance.txt"
	sudo echo 500 > "/home/$account/Current_Balance.txt"
	sudo touch "/home/$account/Transaction_History.txt"
	rm accounts.txt
	exit 0
fi


awk -F' ' '{print $1":"$1"::::/home/"$1":/bin/bash"}' $1 > accounts.txt

for account in $(cut -d: -f1 accounts.txt | cat )
do
	sudo touch "/home/$account/Current_Balance.txt"
	sudo echo 500 > "/home/$account/Current_Balance.txt"
	sudo touch "/home/$account/Transaction_History.txt"
done

cut -d ' ' -f 2 $1 | sort | uniq | sed 's/Branch/MANAGER/' | awk '{print $1":"$1"::::/home/"$1":/bin/bash"}' > manager.txt

newusers accounts.txt
newusers manager.txt

rm accounts.txt
rm manager.txt

