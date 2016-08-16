#! /bin/bash
# clear

HOST=(3.3.3.4 3.3.3.5 3.3.3.6 3.3.3.7 3.3.3.8 3.3.3.9 3.3.3.10 3.3.3.11 3.3.3.12 3.3.3.13)

for i in ${HOST[@]}; do
	for (( j = 1; j <= 4; j++ )); do
		echo $(rm -rf ~/.ssh/known_hosts)
		cekPaket=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@$i -p12345 "asterisk -rx 'gsm send ussd $j *123*5*1*3#'")
		echo $cekPaket
	done
done

