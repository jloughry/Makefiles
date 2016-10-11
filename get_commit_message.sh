#!/bin/sh

message_file="${HOME}/commit_message.txt"

rm -f $message_file
touch $message_file

/bin/echo "Ready to commit; give me a message (it can be multiple lines)"
/bin/echo -n "> "
while read commit_message
	if [ "$commit_message" == "." ] ; then break; fi
	do echo $commit_message >> $message_file
done

