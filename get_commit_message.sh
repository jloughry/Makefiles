#!/bin/sh

message="/tmp/commit_message.txt"

#
# XXX FIXME: This isn't great (because potential race condition) but it's
# probably not a security vulnerability, so do this and get on with other
# work. Better ways to do it include (1) use a Bash variable instead of a
# temporary file to hold the message---but that would require quoting---or
# create the temp file with a unique UUID prefix every time.
#

rm -f $message
touch $message

/bin/echo "12345678901234567890123456789012345678901234567890"
/bin/echo "         1         2         3         4         5"
/bin/echo "Ready to commit; give me a message (it can be multiple lines); end with '.'"
/bin/echo "[Try to keep the description to about fifty chars.]"
/bin/echo -n "> "

read line
while [ "$line" != "." ]
do
    echo $line >> $message
    read line
done

