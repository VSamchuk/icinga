#!/bin/bash
function HELP {
	echo -e \\n"Help documentation for ${BOLD}$0${NORM}. Find files not elder then some period of time"\\n
	echo -e "-d  --Directory"\\n
	echo -e "-m  --Time in minutes"\\n
	echo -e "-w  --WARNING. Count of files lower than value "\\n
	echo -e "-c  --CRITICAL. Count of files lower than value"\\n
	echo -e "-h  --Displays this ${BOLD}h${NORM}elp message"\\n
	echo -e "Example: $0 -d /home/user/dumps -m 60"
	exit 1
}

while getopts :d:m:w:c:h FLAG; do
	case $FLAG in
		d) #set directory pth
			DIRECTORY=$OPTARG
			;;
		m) #set minutes
			MINUTES=$OPTARG
			;;
		w) #set WARNING value
            WARNING=$OPTARG
            ;;
        c) #set CRITICAL value
            CRITICAL=$OPTARG
            ;;
		h) #show help
			HELP
			;;
		*)
			HELP
			;;
	esac
done

FIND_FILES=`find $DIRECTORY -type f -mmin -$MINUTES`
FILES_COUNT=`find $DIRECTORY -type f -mmin -$MINUTES | wc -l`

if ((  $FILES_COUNT < $CRITICAL  ))
then
    echo -e "CRITICAL - $FILES_COUNT files found in $DIRECTORY created last $MINUTES minutes \n$FIND_FILES"
    exit 2
else
    if ((  $FILES_COUNT < $WARNING  ))
    then
        echo -e "WARNING - $FILES_COUNT files found in $DIRECTORY created last $MINUTES minutes \n$FIND_FILES"
        exit 1
    else
        echo -e "$FILES_COUNT files found in $DIRECTORY created last $MINUTES minutes \n$FIND_FILES"
        exit 0
    fi
fi