#!/bin/bash

echo "Enter account number to make transaction(####):"
read accno

number=$(echo $USER | cut -dR -f2)
grep "Branch$number" /etc/passwd | cut -d: -f1 > accounts.txt

occ=$(grep -c "ACC$accno" accounts.txt | cut -d: -f1 )
if [ $occ -eq 0 ]
then
	echo "Account not associated with this branch"
	exit 0;
fi

select type in Withdraw Deposit
do 	
	case $type in
	Withdraw)
		echo "Enter amount to withdraw:"
		read amount
		current_amount=$(cat /home/"ACC$accno"/Current_Balance.txt)
		net_amount=$(echo "scale=10;($current_amount - $amount)/1" | bc )
		if [ $(echo "$net_amount < 0" | bc ) == 1 ]
		then
			echo "Not enough funds"
		else
			echo $net_amount > /home/"ACC$accno"/Current_Balance.txt
			echo "ACC$accno -$amount $(date +'%Y-%m-%d %T')" >> /home/"ACC$accno"/Transaction_History.txt
		fi
		;;
	Deposit)
		echo "Enter amount to deposit:"
		read amount
		current_amount=$(cat /home/"ACC$accno"/Current_Balance.txt)
		net_amount=$(echo "scale=10;($current_amount + $amount)/1" | bc )
		echo $net_amount > /home/"ACC$accno"/Current_Balance.txt
		echo "ACC$accno +$amount $(date +'%Y-%m-%d %T')" >> /home/"ACC$accno"/Transaction_History.txt
		;;
	esac
done

rm accounts.txt

