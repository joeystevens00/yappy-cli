#!/bin/bash
# AUTHOR: Joey Stevens
# File: yappy-notify-when-anyone-texts.sh
# Description: This script uses yappy-cli.sh to demonstrate how to monitor
#	       for unread text messages from anyone
# Limitations: Two text messages in a 5 second period of time will likely blow the script up
#              Last_modified would fix this issue but as of 1/19/2017 it doesn't appear to be implemented
#			   in the Yappy API

# These are required
apiToken=""
deviceIdentifier=""


lastMessage=$(yappy-cli.sh --get=conversations --device=$deviceIdentifier --token=$apiToken | jq ".[] | .[0] | .modified ")

while :; do
	checkForNewMessage=$(yappy-cli.sh --get=conversations --device=$deviceIdentifier --token=$apiToken --modified=$lastMessage)
	checkForNewMessage=$(echo -e "$checkForNewMessage" | jq ".[] | .[0] | .modified ")
	if [ -z "$checkForNewMessage" ] || [ "$checkForNewMessage" == "null" ]; then checkForNewMessage=0; fi
	if [[ $checkForNewMessage > $lastMessage ]]; then
		echo "$checkForNewMessage"
		echo "new text"
		conversations=$(yappy-cli.sh --token=$apiToken --get=conversations --device=$deviceIdentifier --modified=$lastMessage)
		contactName=$(echo -e "$conversations" | jq -r ".[] | .[] | .recipients | .[] | .contact_name")
		notify-send "New text from $contactName"
		lastMessage=$checkForNewMessage
	fi
	sleep 5
done
