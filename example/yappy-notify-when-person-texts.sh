#!/bin/bash
# AUTHOR: Joey Stevens
# File: yappy-notify-when-person-texts.sh
# Description: This script uses yappy-cli.sh to demonstrate how to monitor
#	       for unread text messages for a specific person
#

# These are required
deviceIdentifier=""
conversationIdentifier=""
apiToken=""

notifyPersonTexted() {
        unreadCount=0
        while :; do
                checkUnreadRespone=$(yappy-cli.sh --get=checkunread --device=$deviceIdentifier --token=$apiToken --conversation=$conversationIdentifier)
                checkUnreadCount=$(echo -e "$checkUnreadRespone" | jq -r .unread)
                contactName=$(echo -e "$checkUnreadRespone" | jq -r .contact_name)
                if [ "$checkUnreadCount" -gt 0 ]; then
                        if [ "$unreadCount" == "$checkUnreadCount" ]; then 
                                echo "We already have sent a notification for this new text"
                                sleep 10
                                continue
                        fi
                        echo "This is a new text that we haven't sent a notification for"
                        unreadCount=$checkUnreadCount
                        notify-send "Unread message from $contactName"
                        sleep 10
                        continue
                fi
        echo "No new messages"
        sleep 20
        done
}
notifyPersonTexted
