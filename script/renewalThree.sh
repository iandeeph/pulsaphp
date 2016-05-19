#===============================================================================
#mencari tanggal hari ini dalam format yyyymmdd
#===============================================================================
currentTime=$(date +"[ %Y-%m-%d %H:%M:%S ]")

#===============================================================================
#Konfigurasi Database
#===============================================================================
HOST='1.1.1.200'
USER='root'
PASSWORD='c3rmat'

THREE=($(mysql dbpulsa -h$HOST -u$USER -p$PASSWORD -Bse "select noProvider from provider where namaProvider like 'Three%';"))
# THREE=(089629783240 089629779562 089629789574)
sleep 3m

if [ -t 1 ] ; then #mengecek apakan dijalankan di terminal atau di cronjob, karena cronjob tidak dapat membaca tput
	#===============================================================================
	#Inisialisasi warna text untuk memudahkan membaca output
	#===============================================================================
	red=`tput setaf 1`
	green=`tput setaf 2`
	yellow=`tput setaf 3`
	reset=`tput sgr0`
else
	red=''
	green=''
	yellow=''
fi

echo "$currentTime - Restarting openvox..."
echo "INSERT INTO outbox (DestinationNumber, TextDecoded, CreatorID) VALUES ('${THREE[0]}', 'reboot system c3rmat', 'BashAdmin');"| mysql -h$HOST -u$USER -p$PASSWORD sms
sleep 3m
echo $(rm -rf ~/.ssh/known_hosts)
renewalThreeFx1()
{
	sleep 1m
	echo $(rm -rf ~/.ssh/known_hosts)
	perpanjangThree=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.6 -p12345 "asterisk -rx 'gsm send ussd 1 *123*5*2*1*1#'")
}
renewalThreeFx2()
{
	sleep 1m
	echo $(rm -rf ~/.ssh/known_hosts)
	perpanjangThree=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.6 -p12345 "asterisk -rx 'gsm send ussd 2 *123*5*2*1*1#'")
}
renewalThreeFx3()
{
	sleep 1m
	echo $(rm -rf ~/.ssh/known_hosts)
	perpanjangThree=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.6 -p12345 "asterisk -rx 'gsm send ussd 3 *123*5*2*1*1#'")
}
renewalThreeFx4()
{
	sleep 1m
	echo $(rm -rf ~/.ssh/known_hosts)
	perpanjangThree=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.6 -p12345 "asterisk -rx 'gsm send ussd 4 *123*5*2*1*1#'")
}

numThree=1
maxAttempt=10
maxAttempt=$((maxAttempt+0))
for i in "${THREE[@]}"
do
	echo "$currentTime - ===================================================================================================="
	echo "$currentTime - Perpanjang Paket Three$numThree..."
	echo "$currentTime - ===================================================================================================="
	renewalThreeFx$numThree
	cekString=${perpanjangThree:49:6} # mengecek respon dari openvox
	echo "$currentTime - USSD REPLY${yellow}$perpanjangThree${reset}"

	if [ "$cekString" = "Terima" ]; then #bila respon openvox = Terima
		echo "$currentTime - ${green}Three$numThree Berhasil Perpanjang...${reset}"
		echo "$currentTime - -------------------------------------------------------------------------------------------------------------"
	else
		echo "$currentTime - ${red}Three$numThree Gagal Perpanjang...${reset}"
		echo "$currentTime - -------------------------------------------------------------------------------------------------------------"
		attempt=1
		attempt=$((attempt + 0))
		while [ $attempt -le $maxAttempt ] && [ "$cekBerhasil" != "berhasil"  ]; do
			echo "$currentTime - Three$numThree percobaan ke-$attempt"
			renewalThreeFx$numThree
			cekString=${perpanjangThree:49:6}
			echo "$currentTime - USSD REPLY : ${yellow}$perpanjangThree${reset}"

			if [ "$cekString" = "Terima" ]; then
				echo "$currentTime - ${green}Three$numThree Berhasil Perpanjang...${reset}"
				echo "$currentTime - -------------------------------------------------------------------------------------------------------------"
				cekBerhasil="berhasil"
				attempt=$((attempt + 3))
			else
				cekBerhasil="gagal"
				echo "$currentTime - ${red}Three$numThree Gagal Perpanjang...${reset}"
				echo "$currentTime - ----------------------------------------------"
				attempt=$((attempt + 1))
				sleep 5s
			fi
		done
	fi
	echo "$currentTime - ${yellow}+++++++++++++++++++++++ CHECKING THREE$numThree FINISHED+++++++++++++++++++++${reset}"
	numThree=$((numThree + 1))
done