#!/bin/bash
function HELP {
	echo -e \\n"Help documentation for ${BOLD}$0${NORM}"\\n
	echo -e "-D  --DNS."\\n
	echo -e "-w  --Value for the days before ${BOLD}w${NORM}arning"\\n
	echo -e "-c  --Value for the days before ${BOLD}c${NORM}ritical"\\n
	echo -e "-h  --Displays this ${BOLD}h${NORM}elp message."\\n
	echo -e "Example: $0 -D example.com -w 40 -c 20"\\n
	exit 1
}

while getopts :D:w:c:h FLAG; do
	case $FLAG in
		D) #set domain name
			DOMAIN_NAME=$OPTARG
			;;
		w) #set day before warning
			WARNING_DAYS=$OPTARG
			;;
		c) #set day before critical
			CRITICAL_DAYS=$OPTARG
			;;
		h) #show help
			HELP
			;;
		*)
			HELP
			;;
	esac
done

DATE_ACTUALLY_SECONDS=$(date +"%s")
DATE_EXPIRE_SECONDS=$(whois "${DOMAIN_NAME}" | grep "Expiry Date" | awk '{print $4}' | xargs -I{} date -d {} +%s)
DATE_EXPIRE_FORMAT=$(date -I --date="@${DATE_EXPIRE_SECONDS}")

DATE_DIFFERENCE_SECONDS=$((${DATE_EXPIRE_SECONDS}-${DATE_ACTUALLY_SECONDS}))
DATE_DIFFERENCE_DAYS=$((${DATE_DIFFERENCE_SECONDS}/60/60/24))

if [[ "${DATE_DIFFERENCE_DAYS}" -le "${CRITICAL_DAYS}" && "${DATE_DIFFERENCE_DAYS}" -ge "0" ]]; then
	echo -e "CRITICAL: Domain will expire on: "${DATE_EXPIRE_FORMAT}""
	exit 2
elif [[ "${DATE_DIFFERENCE_DAYS}" -le "${WARNING_DAYS}" && "${DATE_DIFFERENCE_DAYS}" -ge "0" ]]; then
	echo -e "WARNING: Domain will expire on: "${DATE_EXPIRE_FORMAT}""
	exit 1
elif [[ "${DATE_DIFFERENCE_DAYS}" -lt "0" ]]; then
	echo -e "CRITICAL: Domain expired on: "${DATE_EXPIRE_FORMAT}""
	exit 2
else
  echo -e "OK: Domain will expire on: "${DATE_EXPIRE_FORMAT}""
  exit 0
fi