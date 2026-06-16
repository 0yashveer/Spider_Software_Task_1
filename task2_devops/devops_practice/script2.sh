#!/bin/bash

while read file
do
 echo "file : $file"
 echo "wanna edit:(y/n)"
 read choice < /dev/tty

 if [ "$choice" == "y" ]; then
  nano "$file" < /dev/tty
 fi
done < <(find . -name "*.sh")
