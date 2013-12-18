#!/bin/sh

echo "Give me a commit message (it can be multiple lines)"
echo -n "> "
while read commit_message
	do echo $commit_message >> commit_message.txt
done

