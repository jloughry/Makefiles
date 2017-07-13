#!/bin/sh

message="commit_message.txt"

rm -f $message
touch $message

/bin/echo "12345678901234567890123456789012345678901234567890"
/bin/echo "         1         2         3         4         5"
/bin/echo "Ready to commit; give me a message (it can be multiple lines); end with '.'"
/bin/echo "[At most fifty characters is recommended.]"
/bin/echo -n "> "

read line
while [ "$line" != "." ]
do
    echo $line >> $message
    read line
done

