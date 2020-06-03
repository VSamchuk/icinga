#!/bin/sh

ST_OK=0
ST_CR=2

path_pid="/var/run/apache2"
name_pid="apache2.pid"
apache_pid=""
seconds=""

show_time() {
    num=$1
    uptime=$num
    min=0
    hour=0
    day=0
    if [ $num -gt 59 ]
    then
       sec=$((num%60))
       num=$((num/60))
       if [ $num -gt 59 ]
       then
          min=$((num%60))
          num=$((num/60))
          if [ $num -gt 23 ]
          then
             hour=$((num%24))
             day=$((num/24))
          else
                hour=$num
          fi
       else
          min=$num
       fi
    else
       sec=$num
    fi
    echo "Server uptime: "$day"d "$hour"h "$min"m "$sec"s | uptime_seconds=$uptime"
}


if [ -f "$path_pid/$name_pid" ]
then
    apache_pid=`cat $path_pid/$name_pid`
    seconds=`ps -o etimes= -p $apache_pid`
    show_time $seconds
    exit $ST_OK
else
    echo "CRITICAL - Apache is not started"
    exit $ST_CR
fi