#!/bin/bash
# AUTHOR: Joey Stevens
# File: yappy-cli.sh
# Description: This script is a CLI to the Yappy.im API
#
#


default_vars() {
	# This allows you to hardcode values. 
	if [ -z "$apiToken" ]; then apiToken=""; fi
	if [ -z "$deviceIdentifier" ]; then deviceIdentifier=""; fi
	if [ -z "$conversationIdentifier" ]; then conversationIdentifier=""; fi

	# Set defaults to page and results if they're not passed
	if [ -z "$page" ]; then page=1; fi
	if [ -z "$results" ]; then results=200; fi

	ENDPOINT="https://api.yappy.im/v1"
	ENDPOINT_DEVICES="$ENDPOINT/devices"
	ENDPOINT_CONVERSATIONS="$ENDPOINT_DEVICES/$deviceIdentifier/conversations?page=$page&results=$results"
	ENDPOINT_USER="$ENDPOINT/users/me"
	ENDPOINT_CONTACTS="$ENDPOINT_DEVICES/$deviceIdentifier/contacts?page=$page&results=$results"

}


auth_req() {
	# Makes an authenticated request to the URL passed to it
	curl -s -H "Access-Token: $apiToken" $1
}

getDevices() {
	# Returns devices for the user
	auth_req  $ENDPOINT_DEVICES
}

getSingleConversation() {
	# Consumes the conversations object and returns the [identifier] conversation
	conversations=$(getConversations)
	conversation=$(echo -e "$conversations" | jq ".conversations | .[] | select(.identifier==\"$conversationIdentifier\")")
	echo -e "$conversation"
}

checkUnread() {
	# Consumes the conversations object and returns the unread count for [identifier] of the conversation
	# Returns { "unread" : "$unreadCount", "contact_name", "$contact_name" } 

	conversation=$(getSingleConversation)
	contact_name=$(echo -e "$conversation" | jq ".recipients | .[] | .contact_name")
	unreadCount=$(echo -e "$conversation" | jq .unread_SMS_count)
	echo -e "{\"unread\": \"$unreadCount\", \"contact_name\": $contact_name}"
}

getConversations() {
	#  Get a list of conversations belonging to a device. The device must be a phone to have a conversation.
	auth_req $ENDPOINT_CONVERSATIONS

}

getUser() { 
	auth_req $ENDPOINT_USER
}

getContacts() {
	auth_req $ENDPOINT_CONTACTS
}


displayHelp() {
cat << helpcontent
$0 --get=[option] --token=[apiToken] 
e.g: $0 --get=checkunread --conversation=conversationId --device=deviceId --token=apiToken

	-t |--token		the api token to use
	-d |--device		the device identifier to use
					required for get-conversations and get-contacts 
	-c | --conversation	the conversation identifier to use
					required for checkunread and conversation
	-p | --page		determines the page to start on
					defaults to 1
	-r | --results		determines the amount of data to return
					defaults to 200
	-g | --get		Configures the call to use
					Options: contacts, user, conversations, checkunread, conversation
					Always required
helpcontent
exit 1
}

isDeviceIdentifierEmpty() {
	if [ -z "$deviceIdentifier" ]; then 
        	echo "Incorrect usage. Device identifier required. Pass device identifier with --device"
                exit 1
	fi
}

isConversationIdentifierEmpty() {
	if [ -z "$conversationIdentifier" ]; then 
        	echo "Incorrect usage. Conversation identifier required. Pass conversation identifier with --conversation"
                exit 1
        fi
}


argParse() {
	for i in "$@"; do
	case $i in
		-t=*|--token=*)
			apiToken="${i#*=}"
			shift # past argument=value
             		;;
		-d=*|--device=*)
    			deviceIdentifier="${i#*=}"
    			shift # past argument=value
    			;;
    		-c=*|--conversation=*)
    			conversationIdentifier="${i#*=}"
    			shift # past argument=value
    			;;
                -p=*|--page=*)
                        page="${i#*=}"
                        shift # past argument=value
                        ;;
                -r=*|--results=*)
                        results="${i#*=}"
                        shift # past argument=value
                        ;;
                -g=*|--get=*)
                        get="${i#*=}"
                        shift # past argument=value
                        ;;

    		-h|--help)
    			help=true
    			shift # past argument with no value
    			;;
    		*)
	            	help=true # unknown option
    			;;
	esac
	done

	default_vars
	if [ -z "$1" ]; then help=true; fi
	if [ "$help" == true ]; then displayHelp; fi

	# If the user didnt pass a token and they didnt hardcode one... 
	if [ -z "$apiToken" ]; then 
		echo "Not authenticated. Get an API Token from https://www.yappy.im/web/#Settings"
		exit 1
	fi

	if [ -z "$get" ]; then 
		displayHelp
	elif [ "$get" == "contacts" ]; then
		isDeviceIdentifierEmpty
		getContacts
    elif [ "$get" == "user" ]; then
        getUser
    elif [ "$get" == "conversations" ]; then
		isDeviceIdentifierEmpty
        getConversations
    elif [ "$get" == "conversation" ]; then
        isDeviceIdentifierEmpty
		isConversationIdentifierEmpty
		getSingleConversation
    elif [ "$get" == "checkunread" ]; then
        isDeviceIdentifierEmpty
		isConversationIdentifierEmpty
        checkUnread
	else
		displayHelp
        fi
}

argParse "$@"
