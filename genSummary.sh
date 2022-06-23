#!/bin/bash
 grep "MANAGER1" /etc/group | grep "ACC" | cut -dM -f2 | awk -F: '{print $1}' > accounts.txt
 
 if [ $# -eq 0 ] ; then
 
 for account in $(cat accounts.txt)
 do 
 	grep "$account" Branch_Transaction_History.txt >> branch_transaction.txt
 done
 
 sort -t ' ' -k3 branch_transaction.txt -o branch_transaction.txt
 
 cut -d ' ' -f3 branch_transaction.txt | awk -F- 'BEGIN {OFS="-"} {print $1,$2}' | uniq > months.txt
 
 for month in $(cat months.txt)
 do 	
 	echo "Summary for $month :"
 	grep "$month" branch_transaction.txt | grep "ACC" | cut -d ' ' -f1 | sort | uniq > acc_expenditure.txt
 	for account in $(cat acc_expenditure.txt)
 	do
 		grep "$month" branch_transaction.txt | grep "$account" | cut -d ' ' -f2 | awk -v acc=$account 'BEGIN {total=0} {total+=$1} END{print acc,total}' >> expenditure.txt
 	done
 	highest=$(sort -k2g expenditure.txt | tail -n1 | awk '{print $2}')
 	lowest=$(sort -k2g expenditure.txt | head -n1 | awk '{print $2}')
 	if [ $highest -gt 0 ] ; then 
 		grep "$highest" expenditure.txt | awk -v h=$highest 'BEGIN {ORS=" ";print "Highest increase of "h " is for the account"} {print $1} END {printf "\n"}'
 	fi
 	if [ $lowest -lt 0 ] ; then 
 		grep -e "$lowest" expenditure.txt | awk -v l=$lowest 'BEGIN {ORS=" ";print "Highest decrease of "l " is for the account"} {print $1} END {printf "\n"}'
 	fi
 	grep "$month" branch_transaction.txt | awk 'BEGIN {sum=0} {sum += $2} END {print "Mean is "sum/NR}'
 	grep "$month" branch_transaction.txt | sort -t ' ' -k2g -k3 -k4 -k1 > median.txt 
 	lineno=$(wc -l < median.txt)
 	awk -v line=$lineno 'BEGIN {a=0;b=0;sum=0;if ( line%2==0 ) {a=line/2;b=a+1;} else {a=(line+1)/2;b=0;};} {matrix[NR]=$2;} NR==a{if ( b==0 ) {sum+=matrix[NR];print "The median is "sum;} else { sum+=matrix[NR]/2;} } END {if( b!=0 ){sum+=matrix[a+1]/2; print "Median is "sum}}' median.txt
 	mode=$(grep "$month" branch_transaction.txt | cut -d ' ' -f2 | uniq --count | sort -k1n | tail -n1 | awk '{print $1}')
 	if [ $mode -eq 1 ]
 	then
 		echo There is no mode
 	else
 		grep "$month" branch_transaction.txt | cut -d ' ' -f2 | uniq --count | sort -k1n > mode.txt
 		grep "$mode" mode.txt | awk -v m=$mode 'BEGIN {ORS=" ";print "Mode is "m " for the values"} {print $2} END {printf "\n"}'
 		rm mode.txt
 	fi
 	
 	echo
 	
 	rm expenditure.txt
 	
 done
 
 else
 
 for account in $(cat accounts.txt)
 do 
 	grep "$account" $1 >> branch_transaction.txt
 done
 
 sort -t ' ' -k3 branch_transaction.txt -o branch_transaction.txt
 
 cut -d ' ' -f3 branch_transaction.txt | awk -F- 'BEGIN {OFS="-"} {print $1,$2}' | uniq > months.txt
 
 for month in $(cat months.txt)
 do 	
 	echo "Summary for $month :"
 	grep "$month" branch_transaction.txt | grep "ACC" | cut -d ' ' -f1 | sort | uniq > acc_expenditure.txt
 	for account in $(cat acc_expenditure.txt)
 	do
 		grep "$month" branch_transaction.txt | grep "$account" | cut -d ' ' -f2 | awk -v acc=$account 'BEGIN {total=0} {total+=$1} END{print acc,total}' >> expenditure.txt
 	done
 	highest=$(sort -k2g expenditure.txt | tail -n1 | awk '{print $2}')
 	lowest=$(sort -k2g expenditure.txt | head -n1 | awk '{print $2}')
 	if [ $highest -gt 0 ] ; then 
 		grep "$highest" expenditure.txt | awk -v h=$highest 'BEGIN {ORS=" ";print "Highest increase of "h " is for the account"} {print $1} END {printf "\n"}'
 	fi
 	if [ $lowest -lt 0 ] ; then 
 		grep -e "$lowest" expenditure.txt | awk -v l=$lowest 'BEGIN {ORS=" ";print "Highest decrease of "l " is for the account"} {print $1} END {printf "\n"}'
 	fi
 	grep "$month" branch_transaction.txt | awk 'BEGIN {sum=0} {sum += $2} END {print "Mean is "sum/NR}'
 	grep "$month" branch_transaction.txt | sort -t ' ' -k2g -k3 -k4 -k1 > median.txt 
 	lineno=$(wc -l < median.txt)
 	awk -v line=$lineno 'BEGIN {a=0;b=0;sum=0;if ( line%2==0 ) {a=line/2;b=a+1;} else {a=(line+1)/2;b=0;};} {matrix[NR]=$2;} NR==a{if ( b==0 ) {sum+=matrix[NR];print "The median is "sum;} else { sum+=matrix[NR]/2;} } END {if( b!=0 ){sum+=matrix[a+1]/2; print "Median is "sum}}' median.txt
 	mode=$(grep "$month" branch_transaction.txt | cut -d ' ' -f2 | uniq --count | sort -k1n | tail -n1 | awk '{print $1}')
 	if [ $mode -eq 1 ]
 	then
 		echo There is no mode
 	else
 		grep "$month" branch_transaction.txt | cut -d ' ' -f2 | uniq --count | sort -k1n > mode.txt
 		grep "$mode" mode.txt | awk -v m=$mode 'BEGIN {ORS=" ";print "Mode is "m " for the values"} {print $2} END {printf "\n"}'
 		rm mode.txt
 	fi
 	
 	echo
 	
 	rm expenditure.txt
 	
 done
 
 fi
 
 rm accounts.txt
 rm months.txt
 rm median.txt
 rm branch_transaction.txt
 rm acc_expenditure.txt
