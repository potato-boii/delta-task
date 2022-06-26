FROM ubuntu
RUN apt-get clean && apt-get update
RUN apt-get install acl
RUN apt-get install -y bc
RUN apt-get install -y cron
COPY genUser.sh /genUser.sh 
COPY Files/User_Accounts.txt /User_Accounts.txt 
COPY permit.sh /permit.sh 
COPY updateBranch.sh /updateBranch.sh 
COPY allotInterest.sh /allotInterest.sh 
COPY makeTransaction.sh /makeTransaction.sh 
COPY genSummary.sh /genSummary.sh 
COPY Files/Daily_Interest_Rates.txt /Daily_Interest_Rates.txt 
COPY Files/Transaction_History.txt /Transaction_History.txt 
RUN ./genUser.sh User_Accounts.txt
RUN grep 'ACC' /etc/passwd | awk -F ":" '{print $5}' | cut -d ',' -f 2 | sort | uniq > branches.txt
RUN for branch in $(cat branches.txt); do number=$(echo $branch | cut -dh -f2); cp Transaction_History.txt /home/"MANAGER$number"/ ; cp Daily_Interest_Rates.txt /home/"MANAGER$number"/ ; \
    cp updateBranch.sh /home/"MANAGER$number"/ ; cp allotInterest.sh /home/"MANAGER$number"/ ; cp makeTransaction.sh /home/"MANAGER$number"/ ; cp genSummary.sh /home/"MANAGER$number"/ ; \
    cd /home/"MANAGER$number" ; ./updateBranch.sh ; cd / ; (crontab -l; echo "0 0 * * * /bin/bash /home/"MANAGER$number"/allotInterest.sh /home/"MANAGER$number"") | awk '!x[$0]++' | crontab - ; \ 
    done
RUN rm updateBranch.sh
RUN rm allotInterest.sh
RUN rm makeTransaction.sh
RUN rm genSummary.sh
RUN rm Daily_Interest_Rates.txt
RUN rm Transaction_History.txt
RUN ./permit.sh
