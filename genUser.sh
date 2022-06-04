#!/bin/bash

if [ $# -eq 0 ] 
   then
	echo "Enter account number(####):"
	read accno
	echo "Enter branch(Branch1,Branch2,Branch3,Branch4)"
	read branch
	echo "Enter resident type(citizen,resident,foreigner):"
	read restype
	echo "Enter age group(minor,seniorCitizen,-):"
	read agetype
	echo "Legacy account?(legacy,-):"
	read legacy
	echo | awk -v a="$accno" -v b="$branch" -v r="$restype" -v age="$agetype" -v legacy="$legacy" '{print "ACC"a":ACC"a":::ACC"a","b","r","age","legacy":/home/ACC"a":/bin/bash"}' > accounts.txt
	newusers accounts.txt
	account=$(cut -d: -f1 accounts.txt | cat)
	sudo touch "/home/$account/Current_Balance.txt"
	sudo echo 500 > "/home/$account/Current_Balance.txt"
	sudo touch "/home/$account/Transaction_History.txt"
	rm accounts.txt
	exit 0
fi


awk -F' ' '{print $1":"$1":::"$1","$2","$3","$4","$5":/home/"$1":/bin/bash"}' $1 > accounts.txt

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

