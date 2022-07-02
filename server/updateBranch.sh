#!/bin/bash

number=$(echo $USER | cut -dR -f2)
grep "Branch$number" /etc/passwd | cut -d: -f1 > accounts.txt

balance=0

for account in $(cat accounts.txt)
do
	cat "/home/$account/Transaction_History.txt" >> Branch_Transaction_History.txt
	current_balance=$(cat "/home/$account/Current_Balance.txt")
	balance=$(echo "scale=10;($balance + $current_balance)/1" | bc )
done

echo $balance > Branch_Current_Balance.txt

rm accounts.txt
