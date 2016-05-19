
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
#mengambil semua element dalam database, query dari database
#===============================================================================
#===============================================================================
#TELKOMSEL
#===============================================================================
while read telkomselNama telkomselNo telkomselHost telkomselSpan telkomselHargaPaket telkomselExpDatePaket telkomselCaraCekPulsa
do
	telkomselNama+=("$telkomselNama")
	telkomselNo+=("$telkomselNo")
	telkomselHost+=("$telkomselHost")
	telkomselSpan+=("$telkomselSpan")
	telkomselHargaPaket+=("$telkomselHargaPaket")
	telkomselExpDatePaket+=("$telkomselExpDatePaket")
	telkomselCaraCekPulsa+=("$telkomselCaraCekPulsa")
done < <(mysql dbpulsa -h$HOST -u$USER -p$PASSWORD -Bse "select namaProvider, noProvider, host, span hargaPaket, expDatePaket, caraCekPulsa from provider where namaProvider like 'Telkomsel%' order by namaProvider;")
#===============================================================================
#XL
#===============================================================================
while read XLNama XLNo XLHost XLSpan XLHargaPaket XLExpDatePaket XLCaraCekPulsa
do
	XLNama+=("$XLNama")
	XLNo+=("$XLNo")
	XLHost+=("$XLHost")
	XLSpan+=("$XLSpan")
	XLHargaPaket+=("$XLHargaPaket")
	XLExpDatePaket+=("$XLExpDatePaket")
	XLCaraCekPulsa+=("$XLCaraCekPulsa")
done < <(mysql dbpulsa -h$HOST -u$USER -p$PASSWORD -Bse "select namaProvider, noProvider, host, span hargaPaket, expDatePaket, caraCekPulsa from provider where namaProvider like 'XL%' order by namaProvider;")
#===============================================================================
#THREE
#===============================================================================
while read threeNama threeNo threeHost threeSpan threeHargaPaket threeExpDatePaket threeCaraCekPulsa
do
	threeNama+=("$threeNama")
	threeNo+=("$threeNo")
	threeHost+=("$threeHost")
	threeSpan+=("$threeSpan")
	threeHargaPaket+=("$threeHargaPaket")
	threeExpDatePaket+=("$threeExpDatePaket")
	threeCaraCekPulsa+=("$threeCaraCekPulsa")
done < <(mysql dbpulsa -h$HOST -u$USER -p$PASSWORD -Bse "select namaProvider, noProvider, host, span hargaPaket, expDatePaket, caraCekPulsa from provider where namaProvider like 'Three%' order by namaProvider;")

cnt=${#telkomselExpDatePaket[@]} #menghitung total row
for (( i=1 ; i<=${cnt} ; i++ )) #loooping sebanyak total row
do
    telkomselExpDatePaket[$i]=${telkomselExpDatePaket[$i]//[-]/} #merubah dateformat menjadi yyyymmdd yang sebelumnya yyy-dd-mm dengan menghilangkan "-"
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
# TELKOMSEL=($(mysql dbpulsa -h$HOST -u$USER -p$PASSWORD -Bse "select noProvider from provider where namaProvider like 'Telkomsel%';"))
# XL=($(mysql dbpulsa -h$HOST -u$USER -p$PASSWORD -Bse "select noProvider from provider where namaProvider like 'XL%';"))
# INDOSAT=($(mysql dbpulsa -h$HOST -u$USER -p$PASSWORD -Bse "select noProvider from provider where namaProvider like 'Indosat%';"))
# THREE=($(mysql dbpulsa -h$HOST -u$USER -p$PASSWORD -Bse "select noProvider from provider where namaProvider like 'Three%';"))
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
#restarting openvox, tujuannya untuk memastikan cek pulsa dengan kode USSD berhasil.. Karena menurut pengalaman, adakalanya USSD gagal dijalankan..
#metode restart adalah mengirim SMS dengan isi pesan 'reboot system <password> ke masing-masing modul openvox (3.3.3.2, 3.3.3.3, 3.3.3.4 & 3.3.3.5)'
#===============================================================================
echo "$currentTime - Restarting openvox..."
echo "INSERT INTO outbox (DestinationNumber, TextDecoded, CreatorID) VALUES ('${telkomselNo[1]}', 'reboot system c3rmat', 'BashAdmin');"| mysql -h$HOST -u$USER -p$PASSWORD sms
echo "INSERT INTO outbox (DestinationNumber, TextDecoded, CreatorID) VALUES ('${telkomselNo[5]}', 'reboot system c3rmat', 'BashAdmin');"| mysql -h$HOST -u$USER -p$PASSWORD sms
echo "INSERT INTO outbox (DestinationNumber, TextDecoded, CreatorID) VALUES ('${XLNo[1]}', 'reboot system c3rmat', 'BashAdmin');"| mysql -h$HOST -u$USER -p$PASSWORD sms
echo "INSERT INTO outbox (DestinationNumber, TextDecoded, CreatorID) VALUES ('${XLNo[5]}', 'reboot system c3rmat', 'BashAdmin');"| mysql -h$HOST -u$USER -p$PASSWORD sms
echo "INSERT INTO outbox (DestinationNumber, TextDecoded, CreatorID) VALUES ('${threeNo[1]}', 'reboot system c3rmat', 'BashAdmin');"| mysql -h$HOST -u$USER -p$PASSWORD sms

#===============================================================================
#memberikan waktu untuk openvox kembali UP setelah di restart.. 
#===============================================================================
sleep 3m

#===============================================================================
#menghapus file known_host, tujuannya agar setiap kali ssh akan membuat RSA baru.. Jadi tidak ada kegagalan saat pertamakali SSH ke host tersebut..
#===============================================================================
echo $(rm -rf ~/.ssh/known_hosts)

#===============================================================================
#inisialisasi function command script cek pulsa
#===============================================================================
telkomselFx1()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	telkomsel=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${telkomselHost[1]} -p12345 "asterisk -rx 'gsm send ussd ${telkomselSpan[1]} ${telkomselCaraCekPulsa[1]}")
}
telkomselFx2()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	telkomsel=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${telkomselHost[2]} -p12345 "asterisk -rx 'gsm send ussd ${telkomselSpan[2]} ${telkomselCaraCekPulsa[2]}")
}
telkomselFx3()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	telkomsel=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${telkomselHost[3]} -p12345 "asterisk -rx 'gsm send ussd ${telkomselSpan[3]} ${telkomselCaraCekPulsa[3]}")
}
telkomselFx4()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	telkomsel=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${telkomselHost[4]} -p12345 "asterisk -rx 'gsm send ussd ${telkomselSpan[4]} ${telkomselCaraCekPulsa[4]}")
}
telkomselFx5()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	telkomsel=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${telkomselHost[5]} -p12345 "asterisk -rx 'gsm send ussd ${telkomselSpan[5]} ${telkomselCaraCekPulsa[5]}")
}
telkomselFx6()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	telkomsel=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${telkomselHost[6]} -p12345 "asterisk -rx 'gsm send ussd ${telkomselSpan[6]} ${telkomselCaraCekPulsa[6]}")
}
telkomselFx7()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	telkomsel=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${telkomselHost[7]} -p12345 "asterisk -rx 'gsm send ussd ${telkomselSpan[7]} ${telkomselCaraCekPulsa[7]}")
}
telkomselFx8()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	telkomsel=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${telkomselHost[8]} -p12345 "asterisk -rx 'gsm send ussd ${telkomselSpan[8]} ${telkomselCaraCekPulsa[8]}")
}
telkomselFx9()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	telkomsel=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${telkomselHost[9]} -p12345 "asterisk -rx 'gsm send ussd ${telkomselSpan[9]} ${telkomselCaraCekPulsa[9]}")
}

xlFx1()
{
	sleep 1m
	echo $(rm -rf ~/.ssh/known_hosts)
	xl=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.5 -p12345 "asterisk -rx 'gsm send ussd 1 *123#'")
}
xlFx2()
{
	sleep 1m
	echo $(rm -rf ~/.ssh/known_hosts)
	xl=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.5 -p12345 "asterisk -rx 'gsm send ussd 2 *123#'")
}
xlFx3()
{
	sleep 1m
	echo $(rm -rf ~/.ssh/known_hosts)
	xl=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.5 -p12345 "asterisk -rx 'gsm send ussd 3 *123#'")
}
xlFx4()
{
	sleep 1m
	echo $(rm -rf ~/.ssh/known_hosts)
	xl=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.5 -p12345 "asterisk -rx 'gsm send ussd 4 *123#'")
}
xlFx5()
{
	sleep 1m
	echo $(rm -rf ~/.ssh/known_hosts)
	xl=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.4 -p12345 "asterisk -rx 'gsm send ussd 2 *123#'")
}
xlFx6()
{
	sleep 1m
	echo $(rm -rf ~/.ssh/known_hosts)
	xl=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.4 -p12345 "asterisk -rx 'gsm send ussd 3 *123#'")
}
xlFx7()
{
	sleep 1m
	echo $(rm -rf ~/.ssh/known_hosts)
	xl=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.4 -p12345 "asterisk -rx 'gsm send ussd 4 *123#'")
}

# indosatFx1()
# {
# 	echo $(rm -rf ~/.ssh/known_hosts)
# 	indosat=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.4 -p12345 "asterisk -rx 'gsm send ussd 2 *555#'")
# }
# indosatFx2()
# {
# 	echo $(rm -rf ~/.ssh/known_hosts)
# 	indosat=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.4 -p12345 "asterisk -rx 'gsm send ussd 3 *555#'")
# }
# indosatFx3()
# {
# 	echo $(rm -rf ~/.ssh/known_hosts)
# 	indosat=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.4 -p12345 "asterisk -rx 'gsm send ussd 4 *555#'")
# }

threeFx1()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	three=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.6 -p12345 "asterisk -rx 'gsm send ussd 1 *111*1#'")
}
threeFx2()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	three=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.6 -p12345 "asterisk -rx 'gsm send ussd 2 *111*1#'")
}
threeFx3()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	three=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.6 -p12345 "asterisk -rx 'gsm send ussd 3 *111*1#'")
}
threeFx4()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	three=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.6 -p12345 "asterisk -rx 'gsm send ussd 4 *111*1#'")
}


renewalTelkomselFx1()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	perpanjangTelkomsel=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.2 -p12345 "asterisk -rx 'gsm send ussd 1 *999*4*2*1*1#'")
}
renewalTelkomselFx2()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	perpanjangTelkomsel=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.2 -p12345 "asterisk -rx 'gsm send ussd 2 *999*4*2*1*1#'")
}
renewalTelkomselFx3()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	perpanjangTelkomsel=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.2 -p12345 "asterisk -rx 'gsm send ussd 3 *999*4*2*1*1#'")
}
renewalTelkomselFx4()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	perpanjangTelkomsel=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.2 -p12345 "asterisk -rx 'gsm send ussd 4 *999*4*2*1*1#'")
}
renewalTelkomselFx5()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	perpanjangTelkomsel=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.3 -p12345 "asterisk -rx 'gsm send ussd 1 *999*4*3*1*1#'")
}
renewalTelkomselFx6()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	perpanjangTelkomsel=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.3 -p12345 "asterisk -rx 'gsm send ussd 2 *999*4*2*1*1#'")
}
renewalTelkomselFx7()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	perpanjangTelkomsel=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.3 -p12345 "asterisk -rx 'gsm send ussd 3 *999*4*2*1*1#'")
}
renewalTelkomselFx8()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	perpanjangTelkomsel=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.3 -p12345 "asterisk -rx 'gsm send ussd 4 *999*4*2*1*1#'")
}
renewalTelkomselFx9()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	perpanjangTelkomsel=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.4 -p12345 "asterisk -rx 'gsm send ussd 1 *999*4*2*1*1#'")
}

renewalThreeFx()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	perpanjangThree=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.6 -p12345 "asterisk -rx 'gsm send ussd 1 *123*5*1*1*1#'")
}
renewalThreeFx()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	perpanjangThree=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.6 -p12345 "asterisk -rx 'gsm send ussd 2 *123*5*1*1*1#'")
}
renewalThreeFx()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	perpanjangThree=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.6 -p12345 "asterisk -rx 'gsm send ussd 4 *123*5*1*1*1#'")
}

telkomsel[1]=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.2 -p12345 "asterisk -rx 'gsm send ussd 1 *888#'")
sleep 5s
telkomsel[2]=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.2 -p12345 "asterisk -rx 'gsm send ussd 2 *888#'")
sleep 5s
telkomsel[3]=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.2 -p12345 "asterisk -rx 'gsm send ussd 3 *888#'")
sleep 5s
telkomsel[4]=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.2 -p12345 "asterisk -rx 'gsm send ussd 4 *888#'")
sleep 5s
telkomsel[5]=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.3 -p12345 "asterisk -rx 'gsm send ussd 1 *888#'")
sleep 5s
telkomsel[6]=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.3 -p12345 "asterisk -rx 'gsm send ussd 2 *888#'")
sleep 5s
telkomsel[7]=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.3 -p12345 "asterisk -rx 'gsm send ussd 3 *888#'")
sleep 5s
telkomsel[8]=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.3 -p12345 "asterisk -rx 'gsm send ussd 4 *888#'")
sleep 5s
telkomsel[9]=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.4 -p12345 "asterisk -rx 'gsm send ussd 1 *888#'")
sleep 5s

xl[1]=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.5 -p12345 "asterisk -rx 'gsm send ussd 1 *123#'")
sleep 5s
xl[2]=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.5 -p12345 "asterisk -rx 'gsm send ussd 2 *123#'")
sleep 5s
xl[3]=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.5 -p12345 "asterisk -rx 'gsm send ussd 3 *123#'")
sleep 5s
xl[4]=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.5 -p12345 "asterisk -rx 'gsm send ussd 4 *123#'")
sleep 5s
xl[5]=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.4 -p12345 "asterisk -rx 'gsm send ussd 2 *123#'")
sleep 5s
xl[6]=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.4 -p12345 "asterisk -rx 'gsm send ussd 3 *123#'")
sleep 5s
xl[7]=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.4 -p12345 "asterisk -rx 'gsm send ussd 4 *123#'")
sleep 5s

# indosat[1]=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.4 -p12345 "asterisk -rx 'gsm send ussd 2 *555#'")
# sleep 5s
# indosat[2]=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.4 -p12345 "asterisk -rx 'gsm send ussd 3 *555#'")
# sleep 5s
# indosat[3]=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.4 -p12345 "asterisk -rx 'gsm send ussd 4 *555#'")
# sleep 5s

three[1]=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.6 -p12345 "asterisk -rx 'gsm send ussd 1 *111*1#'")
sleep 5s
three[2]=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.6 -p12345 "asterisk -rx 'gsm send ussd 2 *111*1#'")
sleep 5s
three[3]=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.6 -p12345 "asterisk -rx 'gsm send ussd 3 *111*1#'")
sleep 5s
three[4]=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.6 -p12345 "asterisk -rx 'gsm send ussd 4 *111*1#'")
sleep 5s

numSimpati=1
numXl=1
numIndosat=1
numThree=1
maxAttempt=5
maxAttempt=$((maxAttempt+0))

# ==================================================================================================
# Simpati
# ==================================================================================================

for i in "${telkomsel[@]}" #looping sebanyak jumlah variable array
do
	textMintaPulsaSimpati[$numSimpati]="Simpati ${TELKOMSEL[$((numSimpati-1))]}"
	#===============================================================================
	#melakukan cek pulsa untuk masing-masing nomor pada slot openvox
	#metodenya adalah SSH pada openvox dan menjalankan USSD pada asterisk di openvox
	#===============================================================================
	echo "$currentTime - ===================================================================================================="
	echo "$currentTime - Checking Pulsa Telkomsel$numSimpati..."
	echo "$currentTime - ===================================================================================================="
	cekString=${telkomsel[$numSimpati]:2:6} # mengecek respon dari openvox
	cekString2=${telkomsel[$numSimpati]:49:4} # mengecek respon dari openvox

	echo "$currentTime - USSD REPLY : ${yellow}${telkomsel[$numSimpati]}${reset}"

	if [ "$cekString" = "Recive"  ] && [ "$cekString2" != "Maaf"  ]; then #bila respon open = Recive
		echo "$currentTime - ${green}Telkomsel$numSimpati Cek Berhasil...${reset}"
		echo "$currentTime - -------------------------------------------------------------------------------------------------------------"
		telkomsel[$numSimpati]=${telkomsel[$numSimpati]:62:6} #mengambil character yang bernilai jumlah pulsa
		telkomsel[$numSimpati]=${telkomsel[$numSimpati]//[.Aktif]/} #mengabaikan character lain selain angka
		telkomsel[$numSimpati]=$((telkomsel[$numSimpati] + 0)) #merubah variable yang semula string menjadi integer
		echo "$currentTime - ${green}Sisa pulsa Telkomsel$numSimpati : ${telkomsel[$numSimpati]}${reset}"
		#===============================================================================
		#memasukan nilai cek pulsa (pulsa) kedalam database
		#===============================================================================
		# jsonTelkomsel$numSimpati="{namaProvider:\"Telkomsel$numSimpati\", sisaPulsa:\"${telkomsel[$numSimpati]}\", tanggal: \"$mysqlDateNow\"}"
		# echo "INSERT INTO pulsa (namaProvider, sisaPulsa, tanggal) VALUES ('Telkomsel$numSimpati', '${telkomsel[$numSimpati]}', '$mysqlDateNow');"| mysql -h$HOST -u$USER -p$PASSWORD dbpulsa
		sisaPulsaTelkomsel[$numSimpati]=${telkomsel[$numSimpati]}

		if [[ ${telkomsel[$numSimpati]} -lt $HARGA_PAKET_SIMPATI ]]; then #mengecek jika pulsa kurang dari harga paket masing-masing provider
			echo "$currentTime - Kirim SMS ke PIKArin, minta isi pulsa Telkomsel - ${TELKOMSEL[$((numSimpati-1))]}"
			#insert ke database sms untuk mengirim pulsa ke tukang pulsa
			echo "INSERT INTO outbox (DestinationNumber, TextDecoded, CreatorID) VALUES ('$TUKANGPULSA', 'Pikaa ~~ Minta pulsa : ${textMintaPulsaSimpati[$numSimpati]}, sisa pulsa: (${telkomsel[$numSimpati]}), harga paket: $HARGA_PAKET_SIMPATI, Exp Date Paket: ${expDateSimpati[((numSimpati-1))]}', 'BashAdmin');"| mysql -h$HOST -u$USER -p$PASSWORD sms
		fi
	else
		attempt=1
		attempt=$((attempt + 0))
		cekBerhasil=""
		echo "$currentTime - ${red}Telkomsel$numSimpati Cek Gagal...${reset}"
		echo "----------------------------------------------"
		while [[ $attempt -le $maxAttempt && "$cekBerhasil" != "berhasil"  ]]; do
			echo "$currentTime - Telkomsel$numSimpati percobaan ke-$attempt"
			telkomselFx$numSimpati
			cekString=${telkomsel:2:6}
			cekString2=${telkomsel:49:4}
			echo "$currentTime - USSD REPLY : ${yellow}$telkomsel${reset}"

			if [ "$cekString" = "Recive"  ] && [ "$cekString2" != "Maaf"  ]; then
				echo "$currentTime - ${green}Telkomsel$numSimpati Cek Berhasil...${reset}"
				echo "$currentTime - -------------------------------------------------------------------------------------------------------------"
				cekBerhasil="berhasil"
				attempt=$((attempt + 3))
				telkomsel=${telkomsel:62:6}
				telkomsel=${telkomsel//[.Aktif]/}
				telkomsel=$((telkomsel + 0))
				echo "$currentTime - ${green}Sisa pulsa Telkomsel$numSimpati : $telkomsel${reset}"

				#===============================================================================
				#memasukan nilai cek pulsa (pulsa) kedalam database
				#===============================================================================
				# jsonTelkomsel$numSimpati="{namaProvider:\"Telkomsel$numSimpati\", sisaPulsa:\"$telkomsel\", tanggal: \"$mysqlDateNow\"}"
				# echo "INSERT INTO pulsa (namaProvider, sisaPulsa, tanggal) VALUES ('Telkomsel$numSimpati', '$telkomsel', '$mysqlDateNow');"| mysql -h$HOST -u$USER -p$PASSWORD dbpulsa
				sisaPulsaTelkomsel[$numSimpati]=$telkomsel

				if [[ ${telkomsel} -lt $HARGA_PAKET_SIMPATI ]]; then
					echo "$currentTime - Kirim SMS ke PIKArin, minta isi pulsa Telkomsel - ${TELKOMSEL[$((numSimpati-1))]}"
					#insert ke database sms untuk mengirim pulsa ke tukang pulsa
					echo "INSERT INTO outbox (DestinationNumber, TextDecoded, CreatorID) VALUES ('$TUKANGPULSA', 'Pikaa ~~ Minta pulsa : ${textMintaPulsa[$numSimpati]}, sisa pulsa: $telkomsel, harga paket: $HARGA_PAKET_SIMPATI, Exp Date Paket: ${expDateSimpati[((numSimpati-1))]}', 'BashAdmin');"| mysql -h$HOST -u$USER -p$PASSWORD sms
				fi
			else
				cekBerhasil="gagal"
				echo "$currentTime - ${red}Telkomsel$numSimpati Cek Gagal...${reset}"
				echo "----------------------------------------------"
				attempt=$((attempt + 1))
				if [[ $attempt == $maxAttempt ]]; then
					#===============================================================================
					#jika cek gagal,, tetap diinsert dengan nilai "-"
					#===============================================================================
					# jsonTelkomsel$numSimpati="{namaProvider:\"Telkomsel$numSimpati\", sisaPulsa:"-", tanggal: \"$mysqlDateNow\"}"
					# echo "INSERT INTO pulsa (namaProvider, sisaPulsa, tanggal) VALUES ('Telkomsel$numSimpati', '-', '$mysqlDateNow');"| mysql -h$HOST -u$USER -p$PASSWORD dbpulsa
					sisaPulsaTelkomsel[$numSimpati]="-"
				fi
			fi
		done
	fi
	echo "$currentTime - ${green}+++++++++++++++++++++++ CHECKING Telkomsel$numSimpati FINISHED+++++++++++++++++++++${reset}"

	if [[ $NOW -ge ${expDateTelkomsel[$numSimpati]} ]]; then
		echo "$currentTime - ===================================================================================================="
		echo "$currentTime - Perpanjang Paket Telkomsel$numSimpati..."
		echo "$currentTime - ===================================================================================================="
		# ===============================================================================
		# menentukan tanggal baru untuk tanggal habis paket selanjutnya
		# ===============================================================================
		newDate=$(date -d "6 days" +%Y-%m-%d)
		# ===============================================================================
		# mengirim sms ke admin, kalo baru saja paket diperpanjang.. tujuannya agar admin make sure perpanjangan berjalan sesuai dengan seharusnya
		# ===============================================================================
		echo "$currentTime - ${green}Kirim SMS ke Admin, ngasih tau kalo Telkomsel$numSimpati baru aja perpanjang paket.. ${reset}"
		echo "INSERT INTO outbox (DestinationNumber, TextDecoded, CreatorID) VALUES ('$TUKANGKETIK', 'Telkomsel$numSimpati perpanjang paket... coba cek..!!!', 'BashAdmin');"| mysql -h$HOST -u$USER -p$PASSWORD sms
		# ===============================================================================
		# Memanggil funtion
		# ===============================================================================
		renewalTelkomselFx$numSimpati
		cekString=${perpanjangTelkomsel:2:6} # mengecek respon dari openvox
		echo "$currentTime - USSD REPLY${yellow}$perpanjangTelkomsel${reset}"

		if [ "$cekString" = "Recive" ]; then #bila respon openvox = Recive
			echo "$currentTime - ${green}Simpati$numSimpati Berhasil Perpanjang...${reset}"
			echo "$currentTime - -------------------------------------------------------------------------------------------------------------"
			# ===============================================================================
			# jika berhasil maka tanggal exp date akan diupdate
			# ===============================================================================
			mysql -h1.1.1.200 -uroot -pc3rmat dbpulsa -e "update provider set expDatePaket = '$newDate' where namaProvider = 'Telkomsel$numSimpati';"
		else
			echo "$currentTime - ${red}Simpati$numSimpati Gagal Perpanjang...${reset}"
			echo "$currentTime - -------------------------------------------------------------------------------------------------------------"
			attempt=1
			attempt=$((attempt + 0))
			while [[ $attempt -le $maxAttempt && "$cekBerhasil" != "berhasil"  ]]; do
				echo "$currentTime - Telkomsel$numSimpati percobaan ke-$attempt"
				renewalTelkomselFx$numSimpati
				cekString=${perpanjangTelkomsel:2:6}
				echo "$currentTime - USSD REPLY : ${yellow}$perpanjangTelkomsel${reset}"

				if [ "$cekString" = "Recive" ]; then
					echo "$currentTime - ${green}Simpati$numSimpati Berhasil Perpanjang...${reset}"
					echo "$currentTime - -------------------------------------------------------------------------------------------------------------"
					# ===============================================================================
					# jika berhasil maka tanggal exp date akan diupdate
					# ===============================================================================
					mysql -h1.1.1.200 -uroot -pc3rmat dbpulsa -e "update provider set expDatePaket = '$newDate' where namaProvider = 'Telkomsel$numSimpati';"
					cekBerhasil="berhasil"
					attempt=$((attempt + 3))
				else
					cekBerhasil="gagal"
					echo "$currentTime - ${red}Simpati$numSimpati Gagal Perpanjang...${reset}"
					echo "$currentTime - ----------------------------------------------"
					attempt=$((attempt + 1))
					sleep 5s
				fi
			done
		fi
		echo "$currentTime - ${green}+++++++++++++++++++++++ RENEWAL Telkomsel$numSimpati FINISHED+++++++++++++++++++++${reset}"
	fi

	#===============================================================================
	#memasukan nilai cek pulsa kedalam database
	#===============================================================================
	echo "INSERT INTO pulsa (namaProvider, sisaPulsa, tanggal) VALUES ('Telkomsel$numSimpati', '${sisaPulsaTelkomsel[$numSimpati]}', '$mysqlDateNow');"| mysql -h$HOST -u$USER -p$PASSWORD dbpulsa

	numSimpati=$((numSimpati + 1))
done

# #alert Paket Habis Simpati
# #===============================================================================
# #mengecek apakah tanggal habis paket >= hari ini
# #===============================================================================
# if [[ $NOW -ge $NEXT_UPDATE_SIMPATI ]]; then
# 	echo "$currentTime - ===================================================================================================="
# 	echo "$currentTime - Perpanjang Paket Telkomsel"
# 	echo "$currentTime - ===================================================================================================="
# 	# ===============================================================================
# 	# menentukan tanggal baru untuk tanggal habis paket selanjutnya
# 	# ===============================================================================
# 	newDate=$(date -d "6 days" +%Y%m%d)
# 	# ===============================================================================
# 	# mengirim sms ke admin, kalo baru saja paket diperpanjang.. tujuannya agar admin make sure perpanjangan berjalan sesuai dengan seharusnya
# 	# ===============================================================================
# 	echo "$currentTime - ${green}Kirim SMS ke Admin, ngasih tau kalo Telkomsel baru aja perpanjang paket.. ${reset}"
# 	echo "INSERT INTO outbox (DestinationNumber, TextDecoded, CreatorID) VALUES ('$TUKANGKETIK', 'Telkomsel perpanjang paket... coba cek..!!!', 'BashAdmin');"| mysql -h$HOST -u$USER -p$PASSWORD sms

# 	# ===============================================================================
# 	# restarting openvox lagi, alasannya untuk memastikan tidak ada kegagalan saat mengirimkan request ke openvox
# 	# ===============================================================================
# 	echo "$currentTime - Restarting openvox..."
# 	echo "INSERT INTO outbox (DestinationNumber, TextDecoded, CreatorID) VALUES ('${TELKOMSEL[0]}', 'reboot system c3rmat', 'BashAdmin');"| mysql -h$HOST -u$USER -p$PASSWORD sms
# 	echo "INSERT INTO outbox (DestinationNumber, TextDecoded, CreatorID) VALUES ('${TELKOMSEL[5]}', 'reboot system c3rmat', 'BashAdmin');"| mysql -h$HOST -u$USER -p$PASSWORD sms
# 	echo "INSERT INTO outbox (DestinationNumber, TextDecoded, CreatorID) VALUES ('${TELKOMSEL[8]}', 'reboot system c3rmat', 'BashAdmin');"| mysql -h$HOST -u$USER -p$PASSWORD sms
# 	sleep 3m

# 	#===============================================================================
# 	# Perpanjang Paket Via USSD
# 	#===============================================================================
# 	echo "$currentTime - Kirim USSD Perpanjang Paket Simpati"
# 	echo $(rm -rf ~/.ssh/known_hosts)
# 	renewalTelkomsel[1]=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.2 -p12345 "asterisk -rx 'gsm send ussd 1 *999*4*2*1*1#'")
# 	sleep 5s
# 	renewalTelkomsel[2]=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.2 -p12345 "asterisk -rx 'gsm send ussd 2 *999*4*2*1*1#'")
# 	sleep 5s
# 	renewalTelkomsel[3]=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.2 -p12345 "asterisk -rx 'gsm send ussd 3 *999*4*2*1*1#'")
# 	sleep 5s
# 	renewalTelkomsel[4]=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.2 -p12345 "asterisk -rx 'gsm send ussd 4 *999*4*2*1*1#'")
# 	sleep 5s
# 	renewalTelkomsel[5]=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.3 -p12345 "asterisk -rx 'gsm send ussd 1 *999*4*3*1*1#'")
# 	sleep 5s
# 	renewalTelkomsel[6]=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.3 -p12345 "asterisk -rx 'gsm send ussd 2 *999*4*2*1*1#'")
# 	sleep 5s
# 	renewalTelkomsel[7]=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.3 -p12345 "asterisk -rx 'gsm send ussd 3 *999*4*2*1*1#'")
# 	sleep 5s
# 	renewalTelkomsel[8]=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.3 -p12345 "asterisk -rx 'gsm send ussd 4 *999*4*2*1*1#'")
# 	sleep 5s
# 	renewalTelkomsel[9]=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@3.3.3.4 -p12345 "asterisk -rx 'gsm send ussd 1 *999*4*2*1*1#'")

# 	numRenewal=1
# 	for i in "${renewalTelkomsel[@]}" #looping sebanyak jumlah variable array
# 	do
# 		cekString=${renewalTelkomsel[$numRenewal]:2:6} # mengecek respon dari openvox
# 		echo "$currentTime - USSD REPLY${yellow}${renewalTelkomsel[$numRenewal]}${reset}"

# 		if [ "$cekString" = "Recive" ]; then #bila respon openvox = Recive
# 			echo "$currentTime - ${green}Simpati$numRenewal Berhasil Perpanjang...${reset}"
# 			echo "$currentTime - -------------------------------------------------------------------------------------------------------------"
# 			# ===============================================================================
# 			# jika tanggal habis paket adalah >= hari ini, maka paket diperpanjang selama panjangnya masa berlaku paket
# 			# ===============================================================================
# 			echo "$newDate">paketHabisSimpati.txt
# 		else
# 			echo "$currentTime - ${red}Simpati$numRenewal Gagal Perpanjang...${reset}"
# 			echo "$currentTime - -------------------------------------------------------------------------------------------------------------"
# 			attempt=1
# 			attempt=$((attempt + 0))
# 			while [[ $attempt -le $maxAttempt && "$cekBerhasil" != "berhasil"  ]]; do
# 				echo "$currentTime - Telkomsel$numSimpati percobaan ke-$attempt"
# 				renewalTelkomsel$numRenewalFx
# 				cekString=${perpanjangTelkomsel:2:6}
# 				echo "$currentTime - USSD REPLY : ${yellow}$perpanjangTelkomsel${reset}"

# 				if [ "$cekString" = "Recive" ]; then
# 					echo "$currentTime - ${green}Simpati$numRenewal Berhasil Perpanjang...${reset}"
# 					echo "$currentTime - -------------------------------------------------------------------------------------------------------------"
# 					cekBerhasil="berhasil"
# 					attempt=$((attempt + 3))
# 				else
# 					cekBerhasil="gagal"
# 					echo "$currentTime - ${red}Simpati$numRenewal Gagal Perpanjang...${reset}"
# 					echo "$currentTime - ----------------------------------------------"
# 					attempt=$((attempt + 1))
# 					sleep 5s
# 				fi
# 			done
# 		fi
# 		numRenewal=$((numRenewal + 1))
# 	done
# fi

# ==================================================================================================
# XL
# ==================================================================================================
for i in "${xl[@]}" #looping sebanyak jumlah variable array
do
	textMintaPulsa[$numXl]="XL : ${XL[$((numXl-1))]}"
	#===============================================================================
	#melakukan cek pulsa untuk masing-masing nomor pada slot openvox
	#metodenya adalah SSH pada openvox dan menjalankan USSD pada asterisk di openvox
	#===============================================================================
	echo "$currentTime - ===================================================================================================="
	echo "$currentTime - Checking Pulsa XL$numXl..."
	echo "$currentTime - ===================================================================================================="
	cekString=${xl[$numXl]:2:6} # mengecek respon dari openvox
	echo "$currentTime - USSD REPLY : ${yellow}${xl[$numXl]}${reset}"

	if [ "$cekString" = "Recive" ]; then #bila respon open = Recive
		echo "$currentTime - ${green}XL$numXl Cek Berhasil...${reset}"
		echo "$currentTime - -------------------------------------------------------------------------------------------------------------"
		xl[$numXl]=${xl[$numXl]:55:6} #mengambil character yang bernilai jumlah pulsa
		xl[$numXl]=${xl[$numXl]//[ . sd\/ ]/} #mengabaikan character lain selain angka
		xl[$numXl]=$((xl[$numXl] + 0)) #merubah variable yang semula string menjadi integer
		echo "$currentTime - ${green}Sisa Pulsa : ${xl[$numXl]}${reset}"

		#===============================================================================
		#memasukan nilai cek pulsa (pulsa) kedalam database
		#===============================================================================
		# jsonXL$numXl="{namaProvider:\"XL$numXl\", sisaPulsa:\"${xl[$numXl]}\", tanggal: \"$mysqlDateNow\"}"
		# echo "INSERT INTO pulsa (namaProvider, sisaPulsa, tanggal) VALUES ('XL$numXl', '${xl[$numXl]}', '$mysqlDateNow');"| mysql -h$HOST -u$USER -p$PASSWORD dbpulsa
		sisaPulsaXL[$numXl]=${xl[$numXl]}

		if [[ ${xl[$numXl]} -lt $HARGA_PAKET_XL ]]; then #mengecek jika pulsa kurang dari harga paket masing-masing provider
			echo "$currentTime - Kirim SMS ke PIKArin, minta isi pulsa XL - ${XL[$((numXl-1))]}"
			#insert ke database sms untuk mengirim pulsa ke tukang pulsa
			echo "INSERT INTO outbox (DestinationNumber, TextDecoded, CreatorID) VALUES ('$TUKANGPULSA', 'Pikaa ~~ Minta pulsa : ${textMintaPulsa[$numXl]}, sisa pulsa: (${xl[$numXl]}), harga paket: $HARGA_PAKET_XL, Exp Date Paket: ${expDateXL[((numXl-1))]}', 'BashAdmin');"| mysql -h$HOST -u$USER -p$PASSWORD sms
		fi
	else
		attempt=1
		attempt=$((attempt + 0))
		cekBerhasil=""
		echo "$currentTime - ${red}XL$numXl Cek Gagal...${reset}"
		echo "$currentTime - ----------------------------------------------"
		while [[ $attempt -le $maxAttempt && "$cekBerhasil" != "berhasil"  ]]; do
			echo "$currentTime - XL$numXl percobaan ke-$attempt"
			xlFx$numXl
			cekString=${xl:2:6}
			echo "$currentTime - USSD REPLY : ${yellow}$xl${reset}"

			if [ "$cekString" = "Recive" ]; then
				echo "$currentTime - ${green}XL$numXl Cek Berhasil...${reset}"
				echo "$currentTime - -------------------------------------------------------------------------------------------------------------"
				cekBerhasil="berhasil"
				attempt=$((attempt + 3))
				xl=${xl:55:6}
				xl=${xl//[ . sd\/ ]/}
				xl=$((xl + 0))
				echo "$currentTime - ${green}Sisa Pulsa : $xl${reset}"
				
				#===============================================================================
				#memasukan nilai cek pulsa (pulsa) kedalam database
				#===============================================================================
				# jsonXL$numXl="{namaProvider:\"XL$numXl\", sisaPulsa:\"$xl\", tanggal: \"$mysqlDateNow\"}"
				# echo "INSERT INTO pulsa (namaProvider, sisaPulsa, tanggal) VALUES ('XL$numXl', '$xl', '$mysqlDateNow');"| mysql -h$HOST -u$USER -p$PASSWORD dbpulsa
				sisaPulsaXL[$numXl]=$xl

				if [[ ${xl} -lt $HARGA_PAKET_XL ]]; then
					echo "$currentTime - Kirim SMS ke PIKArin, minta isi pulsa XL - ${XL[$((numXl-1))]}"
					#insert ke database sms untuk mengirim pulsa ke tukang pulsa
					echo "INSERT INTO outbox (DestinationNumber, TextDecoded, CreatorID) VALUES ('$TUKANGPULSA', 'Pikaa ~~ Minta pulsa : ${textMintaPulsa[$numXl]}, sisa pulsa: $xl), harga paket: $HARGA_PAKET_XL, Exp Date Paket: ${expDateXL[((numXl-1))]}', 'BashAdmin');"| mysql -h$HOST -u$USER -p$PASSWORD sms
				fi
			else
				cekBerhasil="gagal"
				echo "$currentTime - ${red}XL$numXl Cek Gagal...${reset}"
				echo "$currentTime - ----------------------------------------------"
				
				attempt=$((attempt + 1))
				if [[ $attempt == $maxAttempt ]]; then
					#===============================================================================
					#jika cek gagal,, tetap diinsert dengan nilai "-"
					#===============================================================================
					# jsonXL$numXl="{namaProvider:\"XL$numXl\", sisaPulsa:"-", tanggal: \"$mysqlDateNow\"}"
					# echo "INSERT INTO pulsa (namaProvider, sisaPulsa, tanggal) VALUES ('XL$numXl', '-', '$mysqlDateNow');"| mysql -h$HOST -u$USER -p$PASSWORD dbpulsa
					sisaPulsaXL[$numXl]="-"
				fi
			fi
		done
	fi
	echo "$currentTime - ${yellow}+++++++++++++++++++++++ CHECKING XL$numXl FINISHED+++++++++++++++++++++${reset}"

	#===============================================================================
	#memasukan nilai cek pulsa dan paket kedalam database
	#===============================================================================
	echo "INSERT INTO pulsa (namaProvider, sisaPulsa, tanggal) VALUES ('XL$numXl', '${sisaPulsaXL[$numXl]}', '$mysqlDateNow');"| mysql -h$HOST -u$USER -p$PASSWORD dbpulsa

	numXl=$((numXl + 1))
done

# # ==================================================================================================
# # INDOSAT
# # ==================================================================================================
# for i in "${indosat[@]}" #looping sebanyak jumlah variable array
# do
# 	textMintaPulsa[$numIndosat]="Mentari 100.000 : ${INDOSAT[$((numIndosat-1))]}"
# 	#===============================================================================
# 	#melakukan cek pulsa untuk masing-masing nomor pada slot openvox
# 	#metodenya adalah SSH pada openvox dan menjalankan USSD pada asterisk di openvox
# 	#===============================================================================
# 	echo "$currentTime - ===================================================================================================="
# 	echo "$currentTime - Checking Pulsa INDOSAT$numIndosat..."
# 	echo "$currentTime - ===================================================================================================="
# 	cekString=${indosat[$numIndosat]:2:6} # mengecek respon dari openvox
# 	cekString2=${indosat[$numIndosat]:49:10} # mengecek respon dari openvox
# 	echo "$currentTime - USSD REPLY : ${yellow}${indosat[$numIndosat]}${reset}"

# 	if [ "$cekString" = "Recive"  ] && [ "$cekString2" = "PulsaUTAMA"  ]; then #bila respon open = Recive
# 		echo "$currentTime - ${green}INDOSAT$numIndosat Cek Berhasil...${reset}"
# 		echo "$currentTime - -------------------------------------------------------------------------------------------------------------"
# 		indosat[$numIndosat]=${indosat[$numIndosat]:63:6} #mengambil character yang bernilai jumlah pulsa
# 		indosat[$numIndosat]=${indosat[$numIndosat]//[. Aktif]/} #mengabaikan character lain selain angka
# 		indosat[$numIndosat]=$((indosat[$numIndosat] + 0)) #merubah variable yang semula string menjadi integer
# 		echo "$currentTime - ${green}Sisa Pulsa INDOSAT$numIndosat : ${indosat[$numIndosat]}${reset}"

# 		# jsonIndosat$numIndosat="{namaProvider:\"Indosat$numIndosat\", sisaPulsa:\"${indosat[$numIndosat]}\", tanggal: \"$mysqlDateNow\"}"
# 		echo "INSERT INTO pulsa (namaProvider, sisaPulsa, tanggal) VALUES ('Indosat$numIndosat', '${indosat[$numIndosat]}', '$mysqlDateNow');"| mysql -h$HOST -u$USER -p$PASSWORD dbpulsa

# 		if [[ ${indosat[$numIndosat]} -lt $HARGA_PAKET_INDOSAT ]]; then #mengecek jika pulsa kurang dari harga paket masing-masing provider
# 			echo "$currentTime - Kirim SMS ke PIKArin, minta isi pulsa INDOSAT - ${INDOSAT[$((numIndosat-1))]}"
# 			#insert ke database sms untuk mengirim pulsa ke tukang pulsa
# 			echo "INSERT INTO outbox (DestinationNumber, TextDecoded, CreatorID) VALUES ('$TUKANGPULSA', 'Pikaa ~~ Minta pulsa : ${textMintaPulsa[$numIndosat]}, sisa pulsa: (${indosat[$numIndosat]})', 'BashAdmin');"| mysql -h$HOST -u$USER -p$PASSWORD sms
# 		fi
# 	else
# 		attempt=1
# 		attempt=$((attempt + 0))
# 		cekBerhasil=""
# 		echo "$currentTime - ${red}INDOSAT$numIndosat Cek Gagal...${reset}"
# 		while [[ $attempt -le $maxAttempt && "$cekBerhasil" != "berhasil"  ]]; do
# 			echo "$currentTime - INDOSAT$numIndosat percobaan ke-$attempt"
# 			indosatFx$numIndosat
# 			cekString=${indosat:2:6}
# 			cekString2=${indosat:49:10}
# 			echo "$currentTime - USSD REPLY : ${yellow}$indosat${reset}"

# 			if [ "$cekString" = "Recive"  ] && [ "$cekString2" = "PulsaUTAMA"  ]; then
# 				echo "$currentTime - ${green}INDOSAT$numIndosat Cek Berhasil...${reset}"
# 				echo "$currentTime - -------------------------------------------------------------------------------------------------------------"
# 				cekBerhasil="berhasil"
# 				attempt=$((attempt + 3))
# 				indosat=${indosat:63:6}
# 				indosat=${indosat//[. Aktif]/}
# 				indosat=$((indosat + 0))
# 				echo "$currentTime - ${green}Sisa Pulsa INDOSAT$numIndosat : $indosat${reset}"

# 				# jsonIndosat$numIndosat="{namaProvider:\"Indosat$numIndosat\", sisaPulsa:\"$indosat\", tanggal: \"$mysqlDateNow\"}"
# 				echo "INSERT INTO pulsa (namaProvider, sisaPulsa, tanggal) VALUES ('Indosat$numIndosat', '$indosat', '$mysqlDateNow');"| mysql -h$HOST -u$USER -p$PASSWORD dbpulsa

# 				if [[ ${indosat} -lt $HARGA_PAKET_SIMPATI ]]; then
# 					echo "$currentTime - Kirim SMS ke PIKArin, minta isi pulsa INDOSAT - ${INDOSAT[$((numIndosat-1))]}"
# 					#insert ke database sms untuk mengirim pulsa ke tukang pulsa
# 					echo "INSERT INTO outbox (DestinationNumber, TextDecoded, CreatorID) VALUES ('$TUKANGPULSA', 'Pikaa ~~ Minta pulsa : ${textMintaPulsa[$numIndosat]}, sisa pulsa: $indosat', 'BashAdmin');"| mysql -h$HOST -u$USER -p$PASSWORD sms
# 				fi
# 			else
# 				cekBerhasil="gagal"
# 				echo "$currentTime - ${red}INDOSAT$numIndosat Cek Gagal...${reset}"
# 				echo "$currentTime - ----------------------------------------------"
# 				attempt=$((attempt + 1))
# 				if [[ $attempt == $maxAttempt ]]; then
# 					# jsonIndosat$numIndosat="{namaProvider:\"Indosat$numIndosat\", sisaPulsa:"-", tanggal: \"$mysqlDateNow\"}"
# 					echo "INSERT INTO pulsa (namaProvider, sisaPulsa, tanggal) VALUES ('Indosat$numIndosat', '-', '$mysqlDateNow');"| mysql -h$HOST -u$USER -p$PASSWORD dbpulsa
# 				fi
# 			fi
# 		done
# 	fi
# 	echo "$currentTime - ${yellow}+++++++++++++++++++++++ CHECKING INDOSAT$numIndosat FINISHED+++++++++++++++++++++${reset}"
# 	numIndosat=$((numIndosat + 1))
# done

# ==================================================================================================
# THREE
# ==================================================================================================
for i in "${three[@]}" #looping sebanyak jumlah variable array
do
	textMintaPulsa[$numThree]="Three 50.000 : ${THREE[$((numThree-1))]}"
	#===============================================================================
	#melakukan cek pulsa untuk masing-masing nomor pada slot openvox
	#metodenya adalah SSH pada openvox dan menjalankan USSD pada asterisk di openvox
	#===============================================================================
	echo "$currentTime - ===================================================================================================="
	echo "$currentTime - Checking Pulsa THREE$numThree..."
	echo "$currentTime - ===================================================================================================="
	cekString=${three[$numThree]:2:6} # mengecek respon dari openvox
	cekString2=${three[$numThree]:74:3}
	echo "$currentTime - USSD REPLY : ${yellow}${three[$numThree]}${reset}"

	if [ "$cekString" = "Recive" ] && [ "$cekString2" = "Pul" ]; then #bila respon open = Recive
		echo "$currentTime - ${green}THREE$numThree Cek Berhasil...${reset}"
		echo "$currentTime - -------------------------------------------------------------------------------------------------------------"
		three[$numThree]=${three[$numThree]:82:6} #mengambil character yang bernilai jumlah pulsa
		three[$numThree]=${three[$numThree]//[,Bonus]/} #mengabaikan character lain selain angka
		three[$numThree]=$((three[$numThree] + 0)) #merubah variable yang semula string menjadi integer
		echo "$currentTime - ${green}Sisa Pulsa THREE$numThree : ${three[$numThree]}${reset}"

		# jsonThree$numThree="{namaProvider:\"Three$numThree\", sisaPulsa:\"${three[$numThree]}\", tanggal: \"$mysqlDateNow\"}"
		echo "INSERT INTO pulsa (namaProvider, sisaPulsa, tanggal) VALUES ('Three$numThree', '${three[$numThree]}', '$mysqlDateNow');"| mysql -h$HOST -u$USER -p$PASSWORD dbpulsa

		if [[ ${three[$numThree]} -lt $HARGA_PAKET_THREE ]]; then #mengecek jika pulsa kurang dari harga paket masing-masing provider
			echo "$currentTime - Kirim SMS ke PIKArin, minta isi pulsa THREE - ${THREE[$((numThree-1))]}"
			#insert ke database sms untuk mengirim pulsa ke tukang pulsa
			echo "INSERT INTO outbox (DestinationNumber, TextDecoded, CreatorID) VALUES ('$TUKANGPULSA', 'Pikaa ~~ Minta pulsa : ${textMintaPulsa[$numThree]}, sisa pulsa: (${three[$numThree]}), harga paket: $HARGA_PAKET_THREE, Exp Date Paket: Besok Jam 5 Pagi', 'BashAdmin');"| mysql -h$HOST -u$USER -p$PASSWORD sms
		fi
	else
		attempt=1
		attempt=$((attempt + 0))
		cekBerhasil=""
		echo "$currentTime - ${red}THREE$numThree Cek Gagal...${reset}"
		while [[ $attempt -le $maxAttempt && "$cekBerhasil" != "berhasil"  ]]; do
			echo "$currentTime - THREE$numThree percobaan ke-$attempt"
			threeFx$numThree
			cekString=${three:2:6}
			cekString2=${three:74:3}
			echo "$currentTime - USSD REPLY : ${yellow}$three${reset}"

			if [ "$cekString" = "Recive"  ] && [ "$cekString2" = "Pul"  ]; then
				echo "$currentTime - ${green}THREE$numThree Cek Berhasil...${reset}"
				echo "$currentTime - -------------------------------------------------------------------------------------------------------------"
				cekBerhasil="berhasil"
				attempt=$((attempt + 3))
				three=${three:82:6}
				three=${three//[,Bonus]/}
				three=$((three + 0))
				echo "$currentTime - ${green}Sisa Pulsa THREE$numThree : $three${reset}"

				# jsonThree$numThree="{namaProvider:\"Three$numThree\", sisaPulsa:\"$three\", tanggal: \"$mysqlDateNow\"}"
				echo "INSERT INTO pulsa (namaProvider, sisaPulsa, tanggal) VALUES ('Three$numThree', '$three', '$mysqlDateNow');"| mysql -h$HOST -u$USER -p$PASSWORD dbpulsa

				if [[ ${three} -lt $HARGA_PAKET_SIMPATI ]]; then
					echo "$currentTime - Kirim SMS ke PIKArin, minta isi pulsa THREE - ${THREE[$((numThree-1))]}"
					#insert ke database sms untuk mengirim pulsa ke tukang pulsa
					echo "INSERT INTO outbox (DestinationNumber, TextDecoded, CreatorID) VALUES ('$TUKANGPULSA', 'Pikaa ~~ Minta pulsa : ${textMintaPulsa[$numThree]}, sisa pulsa: $three, harga paket: $HARGA_PAKET_THREE, Exp Date Paket: Besok Jam 5 Pagi', 'BashAdmin');"| mysql -h$HOST -u$USER -p$PASSWORD sms
				fi
			else
				cekBerhasil="gagal"
				echo "$currentTime - ${red}THREE$numThree Cek Gagal...${reset}"
				echo "$currentTime - ----------------------------------------------"
				attempt=$((attempt + 1))
				if [[ $attempt == $maxAttempt ]]; then
					# jsonThree$numThree="{namaProvider:\"Three$numThree\", sisaPulsa:"-", tanggal: \"$mysqlDateNow\"}"
					echo "INSERT INTO pulsa (namaProvider, sisaPulsa, tanggal) VALUES ('Three$numThree', '-', '$mysqlDateNow');"| mysql -h$HOST -u$USER -p$PASSWORD dbpulsa
				fi
			fi
		done
	fi
	echo "$currentTime - ${yellow}+++++++++++++++++++++++ CHECKING THREE$numThree FINISHED+++++++++++++++++++++${reset}"
	numThree=$((numThree + 1))
done