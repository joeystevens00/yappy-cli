# yappy-cli

yappy-cli is a bash CLI to the Yappy.im API

## Usage

```
/usr/bin/yappy-cli.sh --get=[option] --token=[apiToken] [--flag=[options]]
e.g: /usr/bin/yappy-cli.sh --get=checkunread --conversation=conversationId --device=deviceId --token=apiToken

        -t |--token             the api token to use
        -d |--device            the device identifier to use
                                        required for get-conversations and get-contacts 
        -c | --conversation     the conversation identifier to use
                                        required for checkunread and conversation
        -p | --page             determines the page to start on
                                        defaults to 1
        -r | --results          determines the amount of data to return
                                        defaults to 200
        -g | --get              Configures the call to use
                                        Options: contacts, user, conversations, checkunread, conversation, devices
                                        Always required
        -m | --modified only returns data that was modified after [unix timestamp]
                                        can be used with contacts, conversation, conversations, and devices
```

## get flag options

Options: contacts, user, conversations, checkunread, conversation

### contacts
Returns a list of contacts belonging to the device. See [get-contacts](http://docs.yappy.im/contact#getContacts) API docs. The device is set with the --device flag.

### user
Gets information about the user associated with the given Access-Token. See [get-user](http://docs.yappy.im/user#getuser) API docs

### conversations
Get a list of conversations belonging to a device. The device must be a phone to have a conversation. See [get-conversations](http://docs.yappy.im/conversation#getConversations) API docs. The device is set with the --device flag.

### conversation
Returns a single conversation in the conversations object. The conversation to be returned is set with the --conversation flag.

### checkunread
Returns the unread_SMS_count and contact_name for the conversation. 

### devices
Get a list of devices belonging to the current user. See [get-devices](http://docs.yappy.im/device#getDevices) API docs

