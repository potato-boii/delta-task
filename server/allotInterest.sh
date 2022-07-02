#!/bin/bash

#run the command given below to schedule task
#(crontab -l; echo "0 0 * * * /bin/bash /home/$USER/allotInterest.sh /home/$USER") | awk '!x[$0]++' | crontab -
	

	

number=$(echo $USER | cut -dR -f2)
grep "Branch$number" /etc/passwd | cut -d: -f1 > accounts.txt



for account in $(cat /home/$USER/accounts.txt)
do 	
	balance=0
	current_balance=$(cat /home/$account/Current_Balance.txt)
	restype=$(grep $account /etc/passwd | awk -F ":" '{print $5}' | cut -d, -f3 )
	agetype=$(grep $account /etc/passwd | awk -F ":" '{print $5}' | cut -d, -f4 )
	Legacy=$(grep $account /etc/passwd | awk -F ":" '{print $5}' | cut -d, -f5 )
	if [[ $agetype = "minor" ]]
	then
		rate=$(grep $agetype /home/$USER/Daily_Interest_Rates.txt | cut -d ' ' -f2 | cut -d% -f1 | cat )
		rate=$(echo "scale=10;($rate * 0.01)/1" | bc )
		interest=$(echo "scale=10;($rate * $current_balance)/1" | bc )
		balance=$(echo "scale=10;($interest + $balance)/1" | bc )
	fi
	if [[ $agetype = "seniorCitizen" ]]
	then
		rate=$(grep $agetype /home/$USER/Daily_Interest_Rates.txt | cut -d ' ' -f2 | cut -d% -f1 | cat )
		rate=$(echo "scale=10;($rate * 0.01)/1" | bc )
		interest=$(echo "scale=10;($rate * $current_balance)/1" | bc )
		balance=$(echo "scale=10;($interest + $balance)/1" | bc )
	fi
	if [[ $restype = "foreigner" ]]
	then
		rate=$(grep $restype /home/$USER/Daily_Interest_Rates.txt | cut -d ' ' -f2 | cut -d% -f1 | cat )
		rate=$(echo "scale=10;($rate * 0.01)/1" | bc )
		interest=$(echo "scale=10;($rate * $current_balance)/1" | bc )
		balance=$(echo "scale=10;($interest + $balance)/1" | bc )
	fi
	if [[ $restype = "resident" ]]
	then
		rate=$(grep $restype /home/$USER/Daily_Interest_Rates.txt | cut -d ' ' -f2 | cut -d% -f1 | cat )
		rate=$(echo "scale=10;($rate * 0.01)/1" | bc )
		interest=$(echo "scale=10;($rate * $current_balance)/1" | bc )
		balance=$(echo "scale=10;($interest + $balance)/1" | bc )
	fi
	if [[ $restype = "citizen" ]]
	then
		rate=$(grep $restype /home/$USER/Daily_Interest_Rates.txt | cut -d ' ' -f2 | cut -d% -f1 | cat )
		rate=$(echo "scale=10;($rate * 0.01)/1" | bc )
		interest=$(echo "scale=10;($rate * $current_balance)/1" | bc )
		balance=$(echo "scale=10;($interest + $balance)/1" | bc )
	fi
	if [[ $Legacy = "legacy" ]]
	then
		rate=$(grep $Legacy /home/$USER/Daily_Interest_Rates.txt | cut -d ' ' -f2 | cut -d% -f1 | cat )
		rate=$(echo "scale=10;($rate * 0.01)/1" | bc )
		interest=$(echo "scale=10;($rate * $current_balance)/1" | bc )
		balance=$(echo "scale=10;($interest + $balance)/1" | bc )
	fi
	balance=$(echo "scale=10;($balance + $current_balance)/1" | bc )
	echo $balance > /home/$account/Current_Balance.txt
	echo "$account +$balance $(date +'%Y-%m-%d %T')" >> /home/$account/Transaction_History.txt
		
done

rm accounts.txt
