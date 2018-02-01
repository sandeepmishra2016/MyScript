 #!/bin/bash

#Will work well on fac servers
#Author:SandeepMishra

    echo -e "----------------------------DATE--------------------------------------\n"
    date;
    echo -e "----------------------------Uptime------------------------------------\n"
    uptime
    echo -e "------------------------Last logins-----------------------------------\n"
    echo "Last logins:"
    last |head -5
    echo -e "------------------------Disk and memory usage-------------------------\n"
    df -h | xargs | awk '{print "Free/total disk: " $11 " / " $9}'
    free -m | xargs | awk '{print "Free/total memory: " $17 " / " $8 " MB"}'
    echo -e "----------------------Virtual Memory Statistics-----------------------\n"
    vmstat 2 3
    echo -e "---------------------10 largest files from ‘/var/log/’----------------\n"
    find /var/log -mount -type f -ls 2> /dev/null | sort -rnk7 | head -10 | awk '{printf "%10d MB\t%s\n",($7/1024)/1024,$NF}'
    echo "-----------------------10 largest files from ‘/apps’----------------------"
    find /apps -mount -type f -ls 2> /dev/null | sort -rnk7 | head -10 | awk '{printf "%10d MB\t%s\n",($7/1024)/1024,$NF}'
    echo -e "-----------------------10 largest files from ‘/var’-------------------\n"
    find /var/log -mount -type f -ls 2> /dev/null | sort -rnk7 | head -10 | awk '{printf "%10d MB\t%s\n",($7/1024)/1024,$NF}'
    #echo "--------------------------------------------------------------------------"
    #start_log=`sudo head -1 /var/log/messages |cut -c 1-12`
    #oom=`sudo grep -ci error /var/log/messages`
    #echo -n "Errors since $start_log :" $oom
    echo ""
    echo -e "-----------------------Most expensive processes-----------------------\n"
    ps axo rss,comm,pid \
    | awk '{ proc_list[$2] += $1; } END \
    { for (proc in proc_list) { printf("%d\t%s\n", proc_list[proc],proc); }}' \
    | sort -n | tail -n 10 | sort -rn \
    | awk '{$1/=1024;printf "%.0fMB\t",$1}{print $2}'
    echo -e "--------------------------Top 3 output--------------------------------\n"
    top -b |head -10 |tail -4
    echo "--------------------Current Outsystems  DB connections--------------------"
    dbc=$(netstat -an | grep 1521 | grep -i estab | wc -l)
    echo "count:$dbc"
    #echo -e "---------------------------------------------------------------------\n"
    outsystem="/etc/init.d/outsystems"
    jboss="/etc/init.d/jboss-outsystems"
    outsystem_mq="/etc/init.d/jboss-outsystems-mq"
    echo -e "------------------Running Services------------------------------------\n"
        sudo $outsystem status
        sudo $jboss status
        sudo $outsystem_mq status
