#!/bin/bash

while read -r file
do
if [ "$file" == "./script.sh" ]; then
 continue
fi

#err detection for rm -rf

if grep -n "rm -rf" "$file";then

	echo "[WARN] $file Reason:<rm -rf cmd>"
	echo "[$(date '+%F %T')] [WARN] $file found forced remove cmd" >> vault_sweep.log
	echo "wanna edit?(y/n)"
	read choice < /dev/tty

	if [ "$choice" == "y" ]; then
		newFile="${file}.sanitized"
		cp "$file" "$newFile"

		echo "created $newFile"
		nano "$newFile" < /dev/tty

		echo "[$(date '+%F %T')] [FIX] $file removed forced remove" >> vault_sweep.log

	else
		echo "[$(date '+%F %T')] [SKIP] $file left untouched" >> vault_sweep.log
	fi
fi

#err detextion for mkfs

if grep -n "mkfs" "$file"; then
	echo "[WARN] $file Reason:<mkfs cmd>"
	echo "[$(date '+%F %T')] [WARN] $file found format dir cmd" >> vault_sweep.log
	echo "wanna edit?(y/n)"
        read choice < /dev/tty

        if [ "$choice" == "y" ]; then
                newFile="${file}.sanitized"
                cp "$file" "$newFile"

                echo "created $newFile"
                nano "$newFile" < /dev/tty

                echo "[$(date '+%F %T')] [FIXED] $file mkfs fixed" >> vault_sweep.log

        else
                echo "[$(date '+%F %T')] [SKIP] $file file untouched" >> vault_sweep.log
	fi
fi

#insecure permissions
if grep -nE "chmod 777|chmod 757|chmod 717|chmod 707" "$file"; then
	echo "[WARN] $file Reason:<chmod 7x7>"
	echo "[$(date '+%F %T')] [WARN] $file found world write cmd" >> vault_sweep.log
        echo "wanna edit?(y/n)"
        read choice < /dev/tty

        if [ "$choice" == "y" ]; then
                newFile="${file}.sanitized"
                cp "$file" "$newFile"

                echo "created $newFile"
                nano "$newFile" < /dev/tty

                echo "[$(date '+%F %T')] [FIXED] $file world write fixed" >> vault_sweep.log

        else
                echo "[$(date '+%F %T')] [SKIP] $file file untouched" >> vault_sweep.log
	fi
fi

if grep -n -- "-type f -delete" "$file"; then
	echo "[WARN] $file Reason:<-type f -delete>"
        echo "[$(date '+%F %T')] [WARN] $file found forced delete cmd" >> vault_sweep.log
        echo "wanna edit?(y/n)"
        read choice < /dev/tty

        if [ "$choice" == "y" ]; then
                newFile="${file}.sanitized"
                cp "$file" "$newFile"

                echo "created $newFile"
                nano "$newFile" < /dev/tty

                echo "[$(date '+%F %T')] [FIXED] $file forced delete removed" >> vault_sweep.log

        else
                echo "[$(date '+%F %T')] [SKIP] $file file untouched" >> vault_sweep.log
	fi
fi

#dangerous script downloading files:

if grep -nE "curl.*\|\s*bash" "$file"; then
	echo "[WARN] $file Reason:<curl ... | bash>"
        echo "[$(date '+%F %T')] [WARN] $file found unknown script running cmd" >> vault_sweep.log
        echo "wanna edit?(y/n)"
        read choice < /dev/tty

        if [ "$choice" == "y" ]; then
                newFile="${file}.sanitized"
                cp "$file" "$newFile"

                echo "created $newFile"
                nano "$newFile" < /dev/tty

                echo "[$(date '+%F %T')] [FIXED] $file unknown script running removed" >> vault_sweep.log

        else
                echo "[$(date '+%F %T')] [SKIP] $file file untouched" >> vault_sweep.log
	fi
fi

if grep -nE "wget.*\|\s*(bash|sh)" "$file";then
	echo "[WARN] $file Reason:<wget ... | bash>"
        echo "[$(date '+%F %T')] [WARN] $file suspisious executable script cmd" >> vault_sweep.log
        echo "wanna edit?(y/n)"
        read choice < /dev/tty

        if [ "$choice" == "y" ]; then
                newFile="${file}.sanitized"
                cp "$file" "$newFile"

                echo "created $newFile"
                nano "$newFile" < /dev/tty

                echo "[$(date '+%F %T')] [FIXED] $file suspicious download fixed" >> vault_sweep.log

        else
                echo "[$(date '+%F %T')] [SKIP] $file file untouched" >> vault_sweep.log
	fi
fi

#checking syntax errors in .env files
if [[ "$file" == *.env ]]; then

	while IFS= read -r line
	do
	[ -z "$line" ] && continue

	#checking invalid spacing
	if [[ "$line" =~ [[:space:]]=[[:space:]] ]]; then
		echo "[$(date '+%F %T')] [WARN] $file invalid spacing" >> vault_sweep.log
		echo "invalid spacing arround ="
	fi

	#checking key name
	if ! [[ "${line%%=*}" =~ ^[A-Z0-9_]+$ ]]; then
		echo "invalid key name"
		echo "[$(date '+%F %T')] [WARN] $file invalid naming" >> vault_sweep.log
	fi

	#checking quotes
	if [[ "$line" =~ [\'\"] ]]; then
		echo "unnescessary usage of quotes"
		echo "[$(date '+%F %T')] [WARN] $file invalid quoting" >> vault_sweep.log
	fi

	#rejecting eys that modifies system variables
	if [[ "$line" =~ ^(PASSWORD|SECRET|TOKEN|PATH) ]]; then
		echo "dangerous commands"
		echo "[$(date '+%F %T')] [WARN] $file dangerous keywords" >> vault_sweep.log
	fi

	done < "$file"
fi

done < <(find . \( -name "*.sh" -o -name "*.env" \))

