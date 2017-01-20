## yappy-cli

yappy-cli is a bash CLI to the Yappy.im API

## Usage

```
yappy-cli.sh --get=[option] --token=[apiToken] [--flag=[options]]
e.g: yappy-cli.sh --get=checkunread --conversation=conversationId --device=deviceId --token=apiToken

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
                                        Options: contacts, user, conversations, checkunread, conversation
                                        Always required
```

## get flag options

Options: contacts, user, conversations, checkunread, conversation

# contacts
Returns a list of contacts belonging to the device. See [get-contacts](http://docs.yappy.im/contact#getContacts) API docs
