#! /bin/bash
# clear
#===============================================================================
#Konfigurasi Database
#===============================================================================
HOST='1.1.1.200'
USER='root'
PASSWORD='c3rmat'
#===============================================================================
#Inisialisasi harga paket masing-masing provider,, nantinya jika pulsa kurang dari harga paket maka akan minta isi pulsa ke Tukang Pulsa
#===============================================================================
HARGA_PAKET_SIMPATI=12500
HARGA_PAKET_XL=132000
HARGA_PAKET_THREE=5000

#===============================================================================
#inisialisasi tanggal habis paket untuk provider Simpati/Telkomsel
#jika tanggal = hari ini, maka paket akan diperpanjang
#jika paket diperpanjang, maka tanggal akan diupdate / ditambahkan sesuai panjangnya masa berlaku paket
#paket Indosat tidak ada karena Indosat diperpanjang setiap hari selama pulsa mencukupi
#===============================================================================
#===============================================================================
#mengambil tanggal kadaluarsa paket, query dari database (hanya telkomsel)
#===============================================================================
expDateSimpati=($(mysql dbpulsa -h$HOST -u$USER -p$PASSWORD -Bse "select expDatePaket from provider where namaProvider like 'Telkomsel%';"))
expDateXL=($(mysql dbpulsa -h$HOST -u$USER -p$PASSWORD -Bse "select expDatePaket from provider where namaProvider like 'XL%';"))

cnt=${#expDateSimpati[@]} #menghitung total row
for (( i=1 ; i<=${cnt} ; i++ )) #loooping sebanyak total row
do
    expDateTelkomsel[$i]=${expDateSimpati[(($i-1))]} #inisialisasi variable untuk masing2 baris
    expDateTelkomsel[$i]=${expDateTelkomsel[$i]//[-]/} #merubah dateformat menjadi yyyymmdd yang sebelumnya yyy-dd-mm dengan menghilangkan "-"
done

#===============================================================================
#mencari tanggal hari ini dalam format yyyymmdd
#===============================================================================
NOW=$(date +%Y%m%d)
currentTime=$(date +"[ %Y-%m-%d %H:%M:%S ]")
mysqlDateNow=$(date +"%Y-%m-%d %H:%M:%S")

#===============================================================================
#inisialisasi nomor tukang pulsa a.k.a Karin dan tukang ketik a.k.a ian
#===============================================================================
TUKANGPULSA=081381171337
TUKANGKETIK=08992112203

#===============================================================================
#inisialisasi array untuk nomor telp masing-masing provider.. urutan nomor tergantung kepada posisi pada slot openvox..
#===============================================================================
TELKOMSEL=($(mysql dbpulsa -h$HOST -u$USER -p$PASSWORD -Bse "select noProvider from provider where namaProvider like 'Telkomsel%';"))
XL=($(mysql dbpulsa -h$HOST -u$USER -p$PASSWORD -Bse "select noProvider from provider where namaProvider like 'XL%';"))
# INDOSAT=($(mysql dbpulsa -h$HOST -u$USER -p$PASSWORD -Bse "select noProvider from provider where namaProvider like 'Indosat%';"))
THREE=($(mysql dbpulsa -h$HOST -u$USER -p$PASSWORD -Bse "select noProvider from provider where namaProvider like 'Three%';"))
# TELKOMSEL=(081212232674 081212232835 081212232617 081319468847 082112592932 081213374483 081295882084 081295741478 081212232638)
# XL=(081807184805 087886347632 087780867200 087883072681)
# INDOSAT=(085710250739 085710250748 081513779454)
# THREE=(089629783240 089629779562 089629789574)

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
	reset=''
fi

#===============================================================================
#menghapus file known_host, tujuannya agar setiap kali ssh akan membuat RSA baru.. Jadi tidak ada kegagalan saat pertamakali SSH ke host tersebut..
#===============================================================================
echo $(rm -rf ~/.ssh/known_hosts)

#===============================================================================
#inisialisasi function command script cek paket
#===============================================================================
telkomselPaketFx1()
{
	#sleep 1m
	echo $(rm -rf ~/.ssh/known_hosts)
	telkomselPaket=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.2 -p12345 "asterisk -rx 'gsm send ussd 1 *889#'")
}
telkomselPaketFx2()
{
	#sleep 1m
	echo $(rm -rf ~/.ssh/known_hosts)
	telkomselPaket=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.2 -p12345 "asterisk -rx 'gsm send ussd 2 *889#'")
}
telkomselPaketFx3()
{
	#sleep 1m
	echo $(rm -rf ~/.ssh/known_hosts)
	telkomselPaket=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.2 -p12345 "asterisk -rx 'gsm send ussd 3 *889#'")
}
telkomselPaketFx4()
{
	#sleep 1m
	echo $(rm -rf ~/.ssh/known_hosts)
	telkomselPaket=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.2 -p12345 "asterisk -rx 'gsm send ussd 4 *889#'")
}
telkomselPaketFx5()
{
	#sleep 1m
	echo $(rm -rf ~/.ssh/known_hosts)
	telkomselPaket=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.3 -p12345 "asterisk -rx 'gsm send ussd 1 *889#'")
}
telkomselPaketFx6()
{
	#sleep 1m
	echo $(rm -rf ~/.ssh/known_hosts)
	telkomselPaket=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.3 -p12345 "asterisk -rx 'gsm send ussd 2 *889#'")
}
telkomselPaketFx7()
{
	#sleep 1m
	echo $(rm -rf ~/.ssh/known_hosts)
	telkomselPaket=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.3 -p12345 "asterisk -rx 'gsm send ussd 3 *889#'")
}
telkomselPaketFx8()
{
	#sleep 1m
	echo $(rm -rf ~/.ssh/known_hosts)
	telkomselPaket=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.3 -p12345 "asterisk -rx 'gsm send ussd 4 *889#'")
}
telkomselPaketFx9()
{
	#sleep 1m
	echo $(rm -rf ~/.ssh/known_hosts)
	telkomselPaket=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.4 -p12345 "asterisk -rx 'gsm send ussd 1 *889#'")
}

xlPaketFx1()
{
	#sleep 1m
	echo $(rm -rf ~/.ssh/known_hosts)
	xlPaket=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.5 -p12345 "asterisk -rx 'gsm send ussd 1 *123*7*5*1#'")
	sisaPaket=${xlPaket:97:4}
	sisaPaket=${sisaPaket//[lah Mnt,]/}
	sisaPaket=$((sisaPaket + 0))
}
xlPaketFx2()
{
	#sleep 1m
	echo $(rm -rf ~/.ssh/known_hosts)
	xlPaket=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.5 -p12345 "asterisk -rx 'gsm send ussd 2 *123*7*5*1#'")
	sisaPaket=${xlPaket:97:4}
	sisaPaket=${sisaPaket//[lah Mnt,]/}
	sisaPaket=$((sisaPaket + 0))
}
xlPaketFx3()
{
	#sleep 1m
	echo $(rm -rf ~/.ssh/known_hosts)
	xlPaket=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.5 -p12345 "asterisk -rx 'gsm send ussd 3 *123*7*5*1#'")
	sisaPaket=${xlPaket:97:4}
	sisaPaket=${sisaPaket//[lah Mnt,]/}
	sisaPaket=$((sisaPaket + 0))
}
xlPaketFx4()
{
	#sleep 1m
	echo $(rm -rf ~/.ssh/known_hosts)
	xlPaket=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.5 -p12345 "asterisk -rx 'gsm send ussd 4 *123*7*5*1#'")
	sisaPaket=${xlPaket:97:4}
	sisaPaket=${sisaPaket//[lah Mnt,]/}
	sisaPaket=$((sisaPaket + 0))
}
xlPaketFx5()
{
	#sleep 1m
	echo $(rm -rf ~/.ssh/known_hosts)
	xlPaket=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.4 -p12345 "asterisk -rx 'gsm send ussd 2 *123*7*5*1#'")
	sisaPaket=${xlPaket:103:4}
	sisaPaket=${sisaPaket//[lah Mnt,]/}
	sisaPaket=$((sisaPaket + 0))
}
xlPaketFx6()
{
	#sleep 1m
	echo $(rm -rf ~/.ssh/known_hosts)
	xlPaket=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.4 -p12345 "asterisk -rx 'gsm send ussd 3 *123*7*5*1#'")
	sisaPaket=${xlPaket:103:4}
	sisaPaket=${sisaPaket//[lah Mnt,]/}
	sisaPaket=$((sisaPaket + 0))
}
xlPaketFx7()
{
	#sleep 1m
	echo $(rm -rf ~/.ssh/known_hosts)
	xlPaket=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.4 -p12345 "asterisk -rx 'gsm send ussd 4 *123*7*5*1#'")
	sisaPaket=${xlPaket:103:4}
	sisaPaket=${sisaPaket//[lah Mnt,]/}
	sisaPaket=$((sisaPaket + 0))
}

stopXL5()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	#stop paket
	xlStop=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.4 -p12345 "asterisk -rx 'gsm send ussd 2 *123*7*6*1*1#'")
}
renewalValidationXL5()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	#validasi apakah paket yang akan dipasang sudah sesuai atau belum
	validasiPaket=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.4 -p12345 "asterisk -rx 'gsm send ussd 2 *123*4*2*5*1*3*4#'")
	#validasiString2=${telkomselPaket:49:6}
}
renewalExecXL5()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	#perpanjang paket
	xlRenewal=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.4 -p12345 "asterisk -rx 'gsm send ussd 2 *1#'")
	#renewalString2=${telkomselPaket:73:8}
}
renewalXL5()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	#perpanjang paket
	xlRenewalFull=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.4 -p12345 "asterisk -rx 'gsm send ussd 2 *123*4*2*5*1*3*4*1#'")
	#renewalString2=${telkomselPaket:73:8}
}

stopXL6()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	#stop paket
	xlStop=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.4 -p12345 "asterisk -rx 'gsm send ussd 3 *123*7*6*1*1#'")
}
renewalValidationXL6()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	#validasi apakah paket yang akan dipasang sudah sesuai atau belum
	validasiPaket=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.4 -p12345 "asterisk -rx 'gsm send ussd 3 *123*4*2*5*1*3*4#'")
	#validasiString2=${telkomselPaket:49:6}
}
renewalExecXL6()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	#perpanjang paket
	xlRenewal=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.4 -p12345 "asterisk -rx 'gsm send ussd 3 *1#'")
	#renewalString2=${telkomselPaket:73:8}
}
renewalXL6()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	#perpanjang paket
	xlRenewalFull=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.4 -p12345 "asterisk -rx 'gsm send ussd 3 *123*4*2*5*1*3*4*1#'")
	#renewalString2=${telkomselPaket:73:8}
}

stopXL7()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	#stop paket
	xlStop=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.4 -p12345 "asterisk -rx 'gsm send ussd 4 *123*7*6*1*1#'")
}
renewalValidationXL7()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	#validasi apakah paket yang akan dipasang sudah sesuai atau belum
	validasiPaket=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.4 -p12345 "asterisk -rx 'gsm send ussd 4 *123*4*2*5*1*3*4#'")
	#validasiString2=${validasiPaket:49:6}
}
renewalExecXL7()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	#perpanjang paket
	xlRenewal=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.4 -p12345 "asterisk -rx 'gsm send ussd 4 *1#'")
	#renewalString2=${xlRenewal:73:8}
}
renewalXL7()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	#perpanjang paket
	xlRenewalFull=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.4 -p12345 "asterisk -rx 'gsm send ussd 4 *123*4*2*5*1*3*4*1#'")
	#renewalString2=${telkomselPaket:73:8}
}

numSimpati=1
numXl=1
numIndosat=1
numThree=1
maxAttempt=5
maxAttempt=$((maxAttempt+0))

# ==================================================================================================
# Simpati
# ==================================================================================================
for i in "${TELKOMSEL[@]}" #looping sebanyak jumlah variable array
do
	echo "$currentTime - ===================================================================================================="
	echo "$currentTime - Checking PAKET Telkomsel$numSimpati..."
	echo "$currentTime - ===================================================================================================="
	telkomselPaketFx$numSimpati
	cekString=${telkomselPaket:2:6}
	cekString2=${telkomselPaket:49:4}
	cekString3=${telkomselPaket:48:4}

	echo "$currentTime - USSD REPLY : ${yellow}${telkomselPaket}${reset}"

	if [[ "$cekString" = "Recive"  ]]; then #bila respon open = Recive
		if [[ "$cekString2" != "Maaf" ]] || [[ "$cekString3" != "Maaf" ]]; then
			echo "$currentTime - ${green}Telkomsel$numSimpati Cek Paket Berhasil...${reset}"
			echo "$currentTime - -------------------------------------------------------------------------------------------------------------"
			telkomselPaket=${telkomselPaket:62:6} #mengambil character yang bernilai jumlah paket
			telkomselPaket=${telkomselPaket//[i: Men]/} #mengabaikan character lain selain angka
			telkomselPaket=$((telkomselPaket + 0)) #merubah variable yang semula string menjadi integer
			echo "$currentTime - ${green}Sisa paket Telkomsel$numSimpati : ${telkomselPaket}${reset}"

			if [[ $telkomselPaket -gt 150 ]]; then
				telkomselPaket=0
				telkomselPaket=$((telkomselPaket + 0))
			fi

			sisaPaketTelkomsel[$numSimpati]=${telkomselPaket}
		else
			attempt=1
			attempt=$((attempt + 0))
			cekBerhasil=""
			echo "$currentTime - ${red}Telkomsel$numSimpati Cek Paket Gagal...${reset}"
			echo "----------------------------------------------"
			while [[ $attempt -le $maxAttempt && "$cekBerhasil" != "berhasil"  ]]; do
				echo "$currentTime - Telkomsel$numSimpati percobaan ke-$attempt"
				telkomselPaketFx$numSimpati
				cekString=${telkomselPaket:2:6}
				cekString2=${telkomselPaket:49:4}
				echo "$currentTime - USSD REPLY : ${yellow}$telkomselPaket${reset}"

				if [ "$cekString" = "Recive"  ] && [ "$cekString2" != "Maaf" ]; then
					echo "$currentTime - ${green}Telkomsel$numSimpati Cek Paket Berhasil...${reset}"
					echo "$currentTime - -------------------------------------------------------------------------------------------------------------"
					cekBerhasil="berhasil"
					attempt=$((attempt + 3))
					telkomselPaket=${telkomselPaket:62:6}
					telkomselPaket=${telkomselPaket//[i: Men]/}
					telkomselPaket=$((telkomselPaket + 0))
					echo "$currentTime - ${green}Sisa paket Telkomsel$numSimpati : $telkomselPaket${reset}"

					if [[ $telkomselPaket -gt 150 ]]; then
						telkomselPaket=0
						telkomselPaket=$((telkomselPaket + 0))
					fi

					sisaPaketTelkomsel[$numSimpati]=$telkomselPaket
				else
					cekBerhasil="gagal"
					echo "$currentTime - ${red}Telkomsel$numSimpati Cek Gagal...${reset}"
					echo "----------------------------------------------"
					attempt=$((attempt + 1))
					if [[ $attempt == $maxAttempt ]]; then
						sisaPaketTelkomsel[$numSimpati]="-"
					fi
				fi
			done
		fi
	else
		attempt=1
		attempt=$((attempt + 0))
		cekBerhasil=""
		echo "$currentTime - ${red}Telkomsel$numSimpati Cek Paket Gagal...${reset}"
		echo "----------------------------------------------"
		while [[ $attempt -le $maxAttempt && "$cekBerhasil" != "berhasil"  ]]; do
			echo "$currentTime - Telkomsel$numSimpati percobaan ke-$attempt"
			telkomselPaketFx$numSimpati
			cekString=${telkomselPaket:2:6}
			cekString2=${telkomselPaket:49:4}
			echo "$currentTime - USSD REPLY : ${yellow}$telkomselPaket${reset}"

			if [ "$cekString" = "Recive"  ] && [ "$cekString2" != "Maaf" ]; then
				echo "$currentTime - ${green}Telkomsel$numSimpati Cek Paket Berhasil...${reset}"
				echo "$currentTime - -------------------------------------------------------------------------------------------------------------"
				cekBerhasil="berhasil"
				attempt=$((attempt + 3))
				telkomselPaket=${telkomselPaket:62:6}
				telkomselPaket=${telkomselPaket//[i: Men]/}
				telkomselPaket=$((telkomselPaket + 0))
				echo "$currentTime - ${green}Sisa paket Telkomsel$numSimpati : $telkomselPaket${reset}"

				sisaPaketTelkomsel[$numSimpati]=$telkomselPaket
			else
				cekBerhasil="gagal"
				echo "$currentTime - ${red}Telkomsel$numSimpati Cek Gagal...${reset}"
				echo "----------------------------------------------"
				attempt=$((attempt + 1))
				if [[ $attempt == $maxAttempt ]]; then
					sisaPaketTelkomsel[$numSimpati]="-"
				fi
			fi
		done
	fi
	echo "$currentTime - ${green}+++++++++++++++++++++++ CHECKING PAKET Telkomsel$numSimpati FINISHED+++++++++++++++++++++${reset}"

	#===============================================================================
	#memasukan nilai cek paket kedalam database
	#===============================================================================
	echo "INSERT INTO paket (namaProvider, sisaPaket, tanggal) VALUES ('Telkomsel$numSimpati', '${sisaPaketTelkomsel[$numSimpati]}', '$mysqlDateNow');"| mysql -h$HOST -u$USER -p$PASSWORD dbpulsa

	numSimpati=$((numSimpati + 1))
done

# ==================================================================================================
# XL
# ==================================================================================================
for i in "${XL[@]}" #looping sebanyak jumlah variable array
do
	echo "$currentTime - ===================================================================================================="
	echo "$currentTime - Checking Paket XL$numXl..."
	echo "$currentTime - ===================================================================================================="
	xlPaketFx$numXl
	cekString=${xlPaket:2:6} # mengecek respon dari openvox
	cekString2=${xlPaket:49:4} # mengecek respon dari openvox
	echo "$currentTime - USSD REPLY : ${yellow}$xlPaket${reset}"

	if [ "$cekString" = "Recive" ] && [ "$cekString2" = "Sisa" ]; then #bila respon open = Recive
		echo "$currentTime - ${green}XL$numXl Cek Paket Berhasil...${reset}"
		echo "$currentTime - -------------------------------------------------------------------------------------------------------------"
		echo "$currentTime - ${green}Sisa Paket : $sisaPaket${reset}"

		sisaPaketXL[$numXl]=$sisaPaket
	else
		attempt=1
		attempt=$((attempt + 0))
		cekBerhasil=""
		echo "$currentTime - ${red}XL$numXl Cek Pulsa Gagal...${reset}"
		echo "$currentTime - ----------------------------------------------"
		while [[ $attempt -le $maxAttempt && "$cekBerhasil" != "berhasil"  ]]; do
			echo "$currentTime - XL$numXl percobaan ke-$attempt"
			xlPaketFx$numXl
			cekString=${xlPaket:2:6} # mengecek respon dari openvox
			cekString2=${xlPaket:49:4} # mengecek respon dari openvox
			echo "$currentTime - USSD REPLY : ${yellow}$xlPaket${reset}"

			if [ "$cekString" = "Recive" ] && [ "$cekString2" = "Sisa" ]; then
				echo "$currentTime - ${green}XL$numXl Cek Pulsa Berhasil...${reset}"
				echo "$currentTime - -------------------------------------------------------------------------------------------------------------"
				cekBerhasil="berhasil"
				attempt=$((attempt + 3))
				echo "$currentTime - ${green}Sisa Paket : $sisaPaket${reset}"
				
				sisaPaketXL[$numXl]=$sisaPaket
			else
				cekBerhasil="gagal"
				echo "$currentTime - ${red}XL$numXl Cek Paket Gagal...${reset}"
				echo "$currentTime - ----------------------------------------------"
				
				attempt=$((attempt + 1))
				if [[ $attempt == $maxAttempt ]]; then
					sisaPaketXL[$numXl]="-"
				fi
			fi
		done
	fi

	if [[ "${$numXl}" -ge 5 ]] && [[ "${sisaPaketXL[$numXl]}" -le 30 ]]; then #untuk XL5, XL6 dan XL7 && jika sisa paket kurang dari 30 menit maka paket harus di stop dulu, lalu setelah itu dipasang paket yang baru
		stopXL$numXl #function untuk stop paket
		cekString=${xlStop:2:6} # mengecek respon dari openvox
		cekString2=${xlStop:73:8} # mengecek respon dari openvox
		echo "$currentTime - --------------------------------------------------------------"
		echo "$currentTime - STOP PAKET"
		echo "$currentTime - --------------------------------------------------------------"
		echo "$currentTime - USSD REPLY : ${yellow}$xlStop${reset}"
		if [ "$cekString" = "Recive" ] && [ "$cekString2" = "diproses" ]; then #bila respon open = Recive
			echo "$currentTime - ${green}XL$numXl Stop Paket Berhasil...${reset}"
			echo "$currentTime - -------------------------------------------------------------------------------------------------------------"
			stopPaketStatus[$numXl]="berhasil"
		else
			attempt=1
			attempt=$((attempt + 0))
			cekBerhasil=""
			echo "$currentTime - ${red}XL$numXl Stop Paket Gagal...${reset}"
			echo "$currentTime - ----------------------------------------------"
			while [[ $attempt -le $maxAttempt && "$cekBerhasil" != "berhasil"  ]]; do
				echo "$currentTime - XL$numXl percobaan stop ke-$attempt"
				stopXL$numXl #function untuk stop paket
				cekString=${xlStop:2:6} # mengecek respon dari openvox
				cekString2=${xlStop:73:8} # mengecek respon dari openvox
				echo "$currentTime - --------------------------------------------------------------"
				echo "$currentTime - STOP PAKET"
				echo "$currentTime - --------------------------------------------------------------"
				echo "$currentTime - USSD REPLY : ${yellow}$xlStop${reset}"
				if [[ "$cekString" = "Recive" ]] && [[ "$cekString2" = "diproses" ]]; then #bila respon open = Recive
					echo "$currentTime - ${green}XL$numXl Stop Paket Berhasil...${reset}"
					echo "$currentTime - -------------------------------------------------------------------------------------------------------------"
					cekBerhasil="berhasil"
					stopPaketStatus[$numXl]="berhasil"
					attempt=$((attempt + 3))
				else
					cekBerhasil="gagal"
					echo "$currentTime - ${red}XL$numXl Stop Paket Gagal...${reset}"
					echo "$currentTime - ----------------------------------------------"
					
					attempt=$((attempt + 1))
					if [[ $attempt == $maxAttempt ]]; then
						stopPaketStatus[$numXl]="gagal"
					fi
				fi
			done
		fi

		if [[ ${stopPaketStatus[$numXl]} == "berhasil" ]]; then
			renewalValidationXL$numXl
			validasiString=${validasiPaket:2:6}
			validasiString2=${validasiPaket:65:6}
			echo "$currentTime - --------------------------------------------------------------"
			echo "$currentTime - VALIDASI PAKET"
			echo "$currentTime - --------------------------------------------------------------"
			echo "$currentTime - USSD REPLY : ${yellow}$validasiPaket${reset}"
			if [[ "$validasiString" = "Recive" ]] && [[ "$validasiString2" = "AnyNet" ]]; then
				echo "$currentTime - ${green}XL$numXl Validasi Paket Oke...${reset}"
				echo "$currentTime - -------------------------------------------------------------------------------------------------------------"
				echo "$currentTime - ${green}Paket yang akan dipasang  : $validasiString2${reset}"

				renewalExecXL$numXl
				renewalString=${xlRenewal:2:6}
				renewalString2=${xlRenewal:73:8}
				echo "$currentTime - --------------------------------------------------------------"
				echo "$currentTime - EKSEKUSI PERPANJANG PAKET"
				echo "$currentTime - --------------------------------------------------------------"
				echo "$currentTime - USSD REPLY : ${yellow}$xlRenewal${reset}"
				if [[ "$renewalString" = "Recive" ]] && [[ "$renewalString2" = "diproses" ]]; then
					echo "$currentTime - ${green}XL$numXl Perpanjang Paket Berhasil...${reset}"
					echo "$currentTime - -------------------------------------------------------------------------------------------------------------"
					#insert ke database sms untuk ngirim sms notifikasi
					echo "INSERT INTO outbox (DestinationNumber, TextDecoded, CreatorID) VALUES ('$TUKANGKETIK', 'XL$numXl Perpanjang Paket Berhasil, coba cek..!!', 'BashAdmin');"| mysql -h$HOST -u$USER -p$PASSWORD sms
				else
					attempt=1
					attempt=$((attempt + 0))
					cekBerhasil=""
					echo "$currentTime - ${red}XL$numXl Perpanjang Paket Gagal...${reset}"
					echo "$currentTime - ----------------------------------------------"
					while [[ $attempt -le $maxAttempt]] && [["$cekBerhasil" != "berhasil"  ]]; do
						echo "$currentTime - XL$numXl percobaan perpanjang paket ke-$attempt"
						renewalXL$numXl
						cekString=${xlRenewalFull:2:6} # mengecek respon dari openvox
						cekString2=${xlRenewalFull:73:8} # mengecek respon dari openvox
						echo "$currentTime - USSD REPLY : ${yellow}$xlPaket${reset}"

						if [ "$cekString" = "Recive" ] && [ "$cekString2" = "diproses" ]; then
							echo "$currentTime - ${green}XL$numXl Perpanjang Paket Berhasil...${reset}"
							echo "$currentTime - -------------------------------------------------------------------------------------------------------------"
							cekBerhasil="berhasil"
							attempt=$((attempt + 3))
							#insert ke database sms untuk ngirim sms notifikasi
							echo "INSERT INTO outbox (DestinationNumber, TextDecoded, CreatorID) VALUES ('$TUKANGKETIK', 'XL$numXl Perpanjang Paket Berhasil, coba cek..!!', 'BashAdmin');"| mysql -h$HOST -u$USER -p$PASSWORD sms
						else
							cekBerhasil="gagal"
							echo "$currentTime - ${red}XL$numXl Perpanjang Paket Gagal...${reset}"
							echo "$currentTime - ----------------------------------------------"
							
							attempt=$((attempt + 1))
							if [[ $attempt == $maxAttempt ]]; then
								#insert ke database sms untuk ngirim sms notifikasi
								echo "INSERT INTO outbox (DestinationNumber, TextDecoded, CreatorID) VALUES ('$TUKANGKETIK', 'XL$numXl Perpanjang Paket Gagal', 'BashAdmin');"| mysql -h$HOST -u$USER -p$PASSWORD sms
							fi
						fi
					done
				fi
			else
				echo "$currentTime - ${green}XL$numXl Validasi Paket Gagal, Paket yang akan dibeli salah...${reset}"
				echo "$currentTime - -------------------------------------------------------------------------------------------------------------"
				#insert ke database sms untuk ngirim sms notifikasi
				echo "INSERT INTO outbox (DestinationNumber, TextDecoded, CreatorID) VALUES ('$TUKANGKETIK', 'XL$numXl Validasi Paket Gagal,.. Paket yang akan dipasang  : $validasiString2', 'BashAdmin');"| mysql -h$HOST -u$USER -p$PASSWORD sms
			fi
		else
			#insert ke database sms untuk ngirim sms notifikasi
			#echo "INSERT INTO outbox (DestinationNumber, TextDecoded, CreatorID) VALUES ('$TUKANGKETIK', 'XL$numXl paketnya mau abis.. sisa : ${sisaPaketXL[$numXl]}', 'BashAdmin');"| mysql -h$HOST -u$USER -p$PASSWORD sms
			echo "INSERT INTO outbox (DestinationNumber, TextDecoded, CreatorID) VALUES ('$TUKANGKETIK', 'XL$numXl gagal stop paket', 'BashAdmin');"| mysql -h$HOST -u$USER -p$PASSWORD sms
		fi
	fi
	echo "$currentTime - ${yellow}+++++++++++++++++++++++ CHECKING PAKET XL$numXl FINISHED+++++++++++++++++++++${reset}"



	#===============================================================================
	#memasukan nilai cek pulsa dan paket kedalam database
	#===============================================================================
	echo "INSERT INTO paket (namaProvider, sisaPaket, tanggal) VALUES ('XL$numXl', '${sisaPaketXL[$numXl]}', '$mysqlDateNow');"| mysql -h$HOST -u$USER -p$PASSWORD dbpulsa

	numXl=$((numXl + 1))
done