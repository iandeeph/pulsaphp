#! /bin/bash
# clear
#===============================================================================
#Konfigurasi Database
#===============================================================================
HOST='1.1.1.200'
USER='root'
PASSWORD='c3rmat'

#===============================================================================
#Inisialisasi parameter untuk post to slack
#===============================================================================
CHANNEL="#cermati_pulsa"
USERNAME="Pika Pulsa"
ICONEMOJI=":pika-shy:"
ICONEMOJI2=":pikapika:"

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
telkomselResult=($(mysql dbpulsa -h$HOST -u$USER -p$PASSWORD -Bse "select namaProvider, noProvider, host, span, hargaPaket, caraCekKuota from provider where namaProvider like 'Telkomsel%' order by namaProvider;"))
cntTelkomselElm=6
cntTelkomsel=${#telkomselResult[@]}
telkomselSet=$(((cntTelkomsel+1)/cntTelkomselElm))

for (( i=1 ; i<=telkomselSet ; i++ ))
do
	x=$((cntTelkomselElm * (i-1)))
	telkomselNama[$i]=${telkomselResult[$((x + 0 ))]};
	telkomselNo[$i]=${telkomselResult[$((x + 1))]};
	telkomselHost[$i]=${telkomselResult[$((x + 2))]};
	telkomselSpan[$i]=${telkomselResult[$((x + 3))]};
	telkomselHargaPaket[$i]=${telkomselResult[$((x + 4))]};
	telkomselCaraCekPaket[$i]=${telkomselResult[$((x + 5))]};
done
#===============================================================================
#XL
#===============================================================================

XLResult=($(mysql dbpulsa -h$HOST -u$USER -p$PASSWORD -Bse "select namaProvider, noProvider, host, span, hargaPaket, expDatePaket, caraCekKuota, caraStopPaket, caraAktivasi from provider where namaProvider like 'XL%' order by namaProvider;"))
cntXLElm=9
cntXL=${#XLResult[@]}
XLSet=$(((cntXL+1)/cntXLElm))

for (( i=1 ; i<=XLSet ; i++ ))
do
	x=$((cntXLElm * (i-1)))
	XLNama[$i]=${XLResult[$((x + 0 ))]};
	XLNo[$i]=${XLResult[$((x + 1))]};
	XLHost[$i]=${XLResult[$((x + 2))]};
	XLSpan[$i]=${XLResult[$((x + 3))]};
	XLHargaPaket[$i]=${XLResult[$((x + 4))]};
	XLExpDatePaket[$i]=${XLResult[$((x + 5))]};
	XLCaraCekPaket[$i]=${XLResult[$((x + 6))]};
	XLCaraStopPaket[$i]=${XLResult[$((x + 7))]};
	XLCaraAktivasi[$i]=${XLResult[$((x + 8))]};
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
	telkomselPaket=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${telkomselHost[1]} -p12345 "asterisk -rx 'gsm send ussd ${telkomselSpan[1]} ${telkomselCaraCekPaket[1]}'")
}
telkomselPaketFx2()
{
	#sleep 1m 
	echo $(rm -rf ~/.ssh/known_hosts) 
	telkomselPaket=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${telkomselHost[2]} -p12345 "asterisk -rx 'gsm send ussd ${telkomselSpan[2]} ${telkomselCaraCekPaket[2]}'")
}
telkomselPaketFx3()
{
	#sleep 1m 
	echo $(rm -rf ~/.ssh/known_hosts) 
	telkomselPaket=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${telkomselHost[3]} -p12345 "asterisk -rx 'gsm send ussd ${telkomselSpan[3]} ${telkomselCaraCekPaket[3]}'")
}
telkomselPaketFx4()
{
	#sleep 1m 
	echo $(rm -rf ~/.ssh/known_hosts) 
	telkomselPaket=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${telkomselHost[4]} -p12345 "asterisk -rx 'gsm send ussd ${telkomselSpan[4]} ${telkomselCaraCekPaket[4]}'")
}
telkomselPaketFx5()
{
	#sleep 1m 
	echo $(rm -rf ~/.ssh/known_hosts) 
	telkomselPaket=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${telkomselHost[5]} -p12345 "asterisk -rx 'gsm send ussd ${telkomselSpan[5]} ${telkomselCaraCekPaket[5]}'")
}
telkomselPaketFx6()
{
	#sleep 1m 
	echo $(rm -rf ~/.ssh/known_hosts) 
	telkomselPaket=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${telkomselHost[6]} -p12345 "asterisk -rx 'gsm send ussd ${telkomselSpan[6]} ${telkomselCaraCekPaket[6]}'")
}
telkomselPaketFx7()
{
	#sleep 1m 
	echo $(rm -rf ~/.ssh/known_hosts) 
	telkomselPaket=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${telkomselHost[7]} -p12345 "asterisk -rx 'gsm send ussd ${telkomselSpan[7]} ${telkomselCaraCekPaket[7]}'")
}
telkomselPaketFx8()
{
	#sleep 1m 
	echo $(rm -rf ~/.ssh/known_hosts) 
	telkomselPaket=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${telkomselHost[8]} -p12345 "asterisk -rx 'gsm send ussd ${telkomselSpan[8]} ${telkomselCaraCekPaket[8]}'")
}
telkomselPaketFx9()
{
	#sleep 1m 
	echo $(rm -rf ~/.ssh/known_hosts) 
	telkomselPaket=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${telkomselHost[9]} -p12345 "asterisk -rx 'gsm send ussd ${telkomselSpan[9]} ${telkomselCaraCekPaket[9]}'")
}

xlPaketFx1()
{
	#sleep 1m
	echo $(rm -rf ~/.ssh/known_hosts)
	xlPaket=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${XLHost[1]} -p12345 "asterisk -rx 'gsm send ussd ${XLSpan[1]} ${XLCaraCekPaket[1]}'")
	sisaPaket=${xlPaket:97:4}
	sisaPaket=${sisaPaket//[lah Mnt,]/}
	sisaPaket=$((sisaPaket + 0))
}
xlPaketFx2()
{
	#sleep 1m
	echo $(rm -rf ~/.ssh/known_hosts)
	xlPaket=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${XLHost[2]} -p12345 "asterisk -rx 'gsm send ussd ${XLSpan[2]} ${XLCaraCekPaket[2]}'")
	sisaPaket=${xlPaket:97:4}
	sisaPaket=${sisaPaket//[lah Mnt,]/}
	sisaPaket=$((sisaPaket + 0))
}
xlPaketFx3()
{
	#sleep 1m
	echo $(rm -rf ~/.ssh/known_hosts)
	xlPaket=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${XLHost[3]} -p12345 "asterisk -rx 'gsm send ussd ${XLSpan[3]} ${XLCaraCekPaket[3]}'")
	sisaPaket=${xlPaket:97:4}
	sisaPaket=${sisaPaket//[lah Mnt,]/}
	sisaPaket=$((sisaPaket + 0))
}
xlPaketFx4()
{
	#sleep 1m
	echo $(rm -rf ~/.ssh/known_hosts)
	xlPaket=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${XLHost[4]} -p12345 "asterisk -rx 'gsm send ussd ${XLSpan[4]} ${XLCaraCekPaket[4]}'")
	sisaPaket=${xlPaket:97:4}
	sisaPaket=${sisaPaket//[lah Mnt,]/}
	sisaPaket=$((sisaPaket + 0))
}
xlPaketFx5()
{
	#sleep 1m
	echo $(rm -rf ~/.ssh/known_hosts)
	xlPaket=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${XLHost[5]} -p12345 "asterisk -rx 'gsm send ussd ${XLSpan[5]} ${XLCaraCekPaket[5]}'")
	sisaPaket=${xlPaket:103:4}
	sisaPaket=${sisaPaket//[lah Mnt,]/}
	sisaPaket=$((sisaPaket + 0))
}
xlPaketFx6()
{
	#sleep 1m
	echo $(rm -rf ~/.ssh/known_hosts)
	xlPaket=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${XLHost[6]} -p12345 "asterisk -rx 'gsm send ussd ${XLSpan[6]} ${XLCaraCekPaket[6]}'")
	sisaPaket=${xlPaket:103:4}
	sisaPaket=${sisaPaket//[lah Mnt,]/}
	sisaPaket=$((sisaPaket + 0))
}
xlPaketFx7()
{
	#sleep 1m
	echo $(rm -rf ~/.ssh/known_hosts)
	xlPaket=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${XLHost[7]} -p12345 "asterisk -rx 'gsm send ussd ${XLSpan[7]} ${XLCaraCekPaket[7]}'")
	sisaPaket=${xlPaket:103:4}
	sisaPaket=${sisaPaket//[lah Mnt,]/}
	sisaPaket=$((sisaPaket + 0))
}

stopXL1()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	#stop paket
	xlStop=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${XLHost[1]} -p12345 "asterisk -rx 'gsm send ussd ${XLSpan[1]} ${XLCaraStopPaket[1]}'")
}
stopXL2()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	#stop paket
	xlStop=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${XLHost[2]} -p12345 "asterisk -rx 'gsm send ussd ${XLSpan[2]} ${XLCaraStopPaket[2]}'")
}
stopXL3()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	#stop paket
	xlStop=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${XLHost[3]} -p12345 "asterisk -rx 'gsm send ussd ${XLSpan[3]} ${XLCaraStopPaket[3]}'")
}
stopXL4()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	#stop paket
	xlStop=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${XLHost[4]} -p12345 "asterisk -rx 'gsm send ussd ${XLSpan[4]} ${XLCaraStopPaket[4]}'")
}
stopXL5()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	#stop paket
	xlStop=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${XLHost[5]} -p12345 "asterisk -rx 'gsm send ussd ${XLSpan[5]} ${XLCaraStopPaket[5]}'")
}
stopXL6()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	#stop paket
	xlStop=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${XLHost[6]} -p12345 "asterisk -rx 'gsm send ussd ${XLSpan[6]} ${XLCaraStopPaket[6]}'")
}
stopXL7()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	#stop paket
	xlStop=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${XLHost[7]} -p12345 "asterisk -rx 'gsm send ussd ${XLSpan[7]} ${XLCaraStopPaket[7]}'")
}

renewalValidationXL1()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	#validasi apakah paket yang akan dipasang sudah sesuai atau belum
	validasiPaket=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${XLHost[1]} -p12345 "asterisk -rx 'gsm send ussd ${XLSpan[1]} ${XLCaraAktivasi[1]:0:$((${#XLCaraAktivasi[1]} - 3))}"#"'")
	#validasiString2=${telkomselPaket:49:6}
}
renewalValidationXL2()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	#validasi apakah paket yang akan dipasang sudah sesuai atau belum
	validasiPaket=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${XLHost[2]} -p12345 "asterisk -rx 'gsm send ussd ${XLSpan[2]} ${XLCaraAktivasi[2]:0:$((${#XLCaraAktivasi[2]} - 3))}"#"'")
	#validasiString2=${telkomselPaket:49:6}
}
renewalValidationXL3()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	#validasi apakah paket yang akan dipasang sudah sesuai atau belum
	validasiPaket=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${XLHost[3]} -p12345 "asterisk -rx 'gsm send ussd ${XLSpan[3]} ${XLCaraAktivasi[3]:0:$((${#XLCaraAktivasi[3]} - 3))}"#"'")
	#validasiString2=${telkomselPaket:49:6}
}
renewalValidationXL4()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	#validasi apakah paket yang akan dipasang sudah sesuai atau belum
	validasiPaket=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${XLHost[4]} -p12345 "asterisk -rx 'gsm send ussd ${XLSpan[4]} ${XLCaraAktivasi[4]:0:$((${#XLCaraAktivasi[4]} - 3))}"#"'")
	#validasiString2=${telkomselPaket:49:6}
}
renewalValidationXL5()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	#validasi apakah paket yang akan dipasang sudah sesuai atau belum
	validasiPaket=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${XLHost[5]} -p12345 "asterisk -rx 'gsm send ussd ${XLSpan[5]} ${XLCaraAktivasi[5]:0:$((${#XLCaraAktivasi[5]} - 3))}"#"'")
	#validasiString2=${telkomselPaket:49:6}
}
renewalValidationXL6()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	#validasi apakah paket yang akan dipasang sudah sesuai atau belum
	validasiPaket=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${XLHost[6]} -p12345 "asterisk -rx 'gsm send ussd ${XLSpan[6]} ${XLCaraAktivasi[6]:0:$((${#XLCaraAktivasi[6]} - 3))}"#"'")
	#validasiString2=${telkomselPaket:49:6}
}
renewalValidationXL7()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	#validasi apakah paket yang akan dipasang sudah sesuai atau belum
	validasiPaket=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${XLHost[7]} -p12345 "asterisk -rx 'gsm send ussd ${XLSpan[7]} ${XLCaraAktivasi[7]:0:$((${#XLCaraAktivasi[7]} - 3))}"#"'")
	#validasiString2=${validasiPaket:49:6}
}

renewalExecXL1()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	#perpanjang paket
	xlRenewal=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${XLHost[1]} -p12345 "asterisk -rx 'gsm send ussd ${XLSpan[1]} ${XLCaraAktivasi[1]:$((${#XLCaraAktivasi[1]} - 3)):3}'")
	#renewalString2=${telkomselPaket:73:8}
}
renewalExecXL2()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	#perpanjang paket
	xlRenewal=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${XLHost[2]} -p12345 "asterisk -rx 'gsm send ussd ${XLSpan[2]} ${XLCaraAktivasi[2]:$((${#XLCaraAktivasi[2]} - 3)):3}'")
	#renewalString2=${telkomselPaket:73:8}
}
renewalExecXL3()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	#perpanjang paket
	xlRenewal=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${XLHost[3]} -p12345 "asterisk -rx 'gsm send ussd ${XLSpan[3]} ${XLCaraAktivasi[3]:$((${#XLCaraAktivasi[3]} - 3)):3}'")
	#renewalString2=${telkomselPaket:73:8}
}
renewalExecXL4()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	#perpanjang paket
	xlRenewal=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${XLHost[4]} -p12345 "asterisk -rx 'gsm send ussd ${XLSpan[4]} ${XLCaraAktivasi[4]:$((${#XLCaraAktivasi[4]} - 3)):3}'")
	#renewalString2=${telkomselPaket:73:8}
}
renewalExecXL5()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	#perpanjang paket
	xlRenewal=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${XLHost[5]} -p12345 "asterisk -rx 'gsm send ussd ${XLSpan[5]} ${XLCaraAktivasi[5]:$((${#XLCaraAktivasi[5]} - 3)):3}'")
	#renewalString2=${telkomselPaket:73:8}
}
renewalExecXL6()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	#perpanjang paket
	xlRenewal=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${XLHost[6]} -p12345 "asterisk -rx 'gsm send ussd ${XLSpan[6]} ${XLCaraAktivasi[6]:$((${#XLCaraAktivasi[6]} - 3)):3}'")
	#renewalString2=${telkomselPaket:73:8}
}
renewalExecXL7()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	#perpanjang paket
	xlRenewal=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${XLHost[7]} -p12345 "asterisk -rx 'gsm send ussd ${XLSpan[7]} ${XLCaraAktivasi[7]:$((${#XLCaraAktivasi[7]} - 3)):3}'")
	#renewalString2=${xlRenewal:73:8}
}

renewalXL1()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	#perpanjang paket
	xlRenewalFull=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${XLHost[1]} -p12345 "asterisk -rx 'gsm send ussd ${XLSpan[1]} ${XLCaraAktivasi[1]}'")
	#renewalString2=${telkomselPaket:73:8}
}
renewalXL2()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	#perpanjang paket
	xlRenewalFull=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${XLHost[2]} -p12345 "asterisk -rx 'gsm send ussd ${XLSpan[2]} ${XLCaraAktivasi[2]}'")
	#renewalString2=${telkomselPaket:73:8}
}
renewalXL3()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	#perpanjang paket
	xlRenewalFull=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${XLHost[3]} -p12345 "asterisk -rx 'gsm send ussd ${XLSpan[3]} ${XLCaraAktivasi[3]}'")
	#renewalString2=${telkomselPaket:73:8}
}
renewalXL4()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	#perpanjang paket
	xlRenewalFull=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${XLHost[4]} -p12345 "asterisk -rx 'gsm send ussd ${XLSpan[4]} ${XLCaraAktivasi[4]}'")
	#renewalString2=${telkomselPaket:73:8}
}
renewalXL5()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	#perpanjang paket
	xlRenewalFull=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${XLHost[5]} -p12345 "asterisk -rx 'gsm send ussd ${XLSpan[5]} ${XLCaraAktivasi[5]}'")
	#renewalString2=${telkomselPaket:73:8}
}
renewalXL6()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	#perpanjang paket
	xlRenewalFull=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${XLHost[6]} -p12345 "asterisk -rx 'gsm send ussd ${XLSpan[6]} ${XLCaraAktivasi[6]}'")
	#renewalString2=${telkomselPaket:73:8}
}
renewalXL7()
{
	echo $(rm -rf ~/.ssh/known_hosts)
	#perpanjang paket
	xlRenewalFull=$(sshpass -padmin ssh -o StrictHostKeyChecking=no admin@${XLHost[7]} -p12345 "asterisk -rx 'gsm send ussd ${XLSpan[7]} ${XLCaraAktivasi[7]}'")
	#renewalString2=${telkomselPaket:73:8}
}

numSimpati=1
numXL=1
numIndosat=1
numThree=1
maxAttempt=5
maxAttempt=$((maxAttempt+0))

# ==================================================================================================
# Simpati
# ==================================================================================================
for i in "${telkomselNo[@]}" #looping sebanyak jumlah variable array
do
	echo "$currentTime - ===================================================================================================="
	echo "$currentTime - Checking PAKET ${telkomselNama[$numSimpati]}..."
	echo "$currentTime - ===================================================================================================="
	telkomselPaketFx$numSimpati
	cekString=${telkomselPaket:2:6}
	cekString2=${telkomselPaket:49:4}
	cekString3=${telkomselPaket:48:4}

	echo "$currentTime - USSD REPLY : ${yellow}$telkomselPaket${reset}"

	if [[ "$cekString" = "Recive"  ]]; then #bila respon open = Recive
		if [[ "$cekString2" != "Maaf" ]] || [[ "$cekString3" != "Maaf" ]]; then
			echo "$currentTime - ${green}${telkomselNama[$numSimpati]} Cek Paket Berhasil...${reset}"
			echo "$currentTime - -------------------------------------------------------------------------------------------------------------"
			USSDReplyTelkomsel[$numSimpati]="${telkomselPaket}"
			telkomselPaket=${telkomselPaket:62:6} #mengambil character yang bernilai jumlah paket
			telkomselPaket=${telkomselPaket//[i: Men dtk]/} #mengabaikan character lain selain angka
			telkomselPaket=$((telkomselPaket + 0)) #merubah variable yang semula string menjadi integer
			echo "$currentTime - ${green}Sisa paket ${telkomselNama[$numSimpati]} : ${telkomselPaket}${reset}"

			if [[ $telkomselPaket -gt 150 ]]; then
				telkomselPaket=0
				telkomselPaket=$((telkomselPaket + 0))
			fi

			sisaPaketTelkomsel[$numSimpati]=${telkomselPaket}
		else
			attempt=1
			attempt=$((attempt + 0))
			cekBerhasil=""
			echo "$currentTime - ${red}${telkomselNama[$numSimpati]} Cek Paket Gagal...${reset}"
			echo "----------------------------------------------"
			while [[ $attempt -le $maxAttempt && "$cekBerhasil" != "berhasil"  ]]; do
				echo "$currentTime - ${telkomselNama[$numSimpati]} percobaan ke-$attempt"
				telkomselPaketFx$numSimpati
				cekString=${telkomselPaket:2:6}
				cekString2=${telkomselPaket:49:4}
				cekString3=${telkomselPaket:48:4}

				echo "$currentTime - USSD REPLY : ${yellow}$telkomselPaket${reset}"
				USSDReplyTelkomsel[$numSimpati]="$telkomselPaket"

				if [[ "$cekString" = "Recive"  ]]; then #bila respon open = Recive
					if [[ "$cekString2" != "Maaf" ]] || [[ "$cekString3" != "Maaf" ]]; then
						echo "$currentTime - ${green}${telkomselNama[$numSimpati]} Cek Paket Berhasil...${reset}"
						echo "$currentTime - -------------------------------------------------------------------------------------------------------------"
						telkomselPaket=${telkomselPaket:62:6} #mengambil character yang bernilai jumlah paket
						telkomselPaket=${telkomselPaket//[i: Men dtk]/} #mengabaikan character lain selain angka
						telkomselPaket=$((telkomselPaket + 0)) #merubah variable yang semula string menjadi integer
						echo "$currentTime - ${green}Sisa paket ${telkomselNama[$numSimpati]} : ${telkomselPaket}${reset}"

						if [[ $telkomselPaket -gt 150 ]]; then
							telkomselPaket=0
							telkomselPaket=$((telkomselPaket + 0))
						fi

						sisaPaketTelkomsel[$numSimpati]=${telkomselPaket}
					else
						cekBerhasil="gagal"
						echo "$currentTime - ${red}${telkomselNama[$numSimpati]} Cek Gagal...${reset}"
						echo "----------------------------------------------"
						attempt=$((attempt + 1))
						if [[ $attempt == $maxAttempt ]]; then
							sisaPaketTelkomsel[$numSimpati]=0
						fi
					fi
				else
					cekBerhasil="gagal"
					echo "$currentTime - ${red}${telkomselNama[$numSimpati]} Cek Gagal...${reset}"
					echo "----------------------------------------------"
					attempt=$((attempt + 1))
					if [[ $attempt == $maxAttempt ]]; then
						sisaPaketTelkomsel[$numSimpati]=0
					fi
				fi
			done
		fi
	else
		attempt=1
		attempt=$((attempt + 0))
		cekBerhasil=""
		echo "$currentTime - ${red}${telkomselNama[$numSimpati]} Cek Paket Gagal...${reset}"
		echo "----------------------------------------------"
		while [[ $attempt -le $maxAttempt && "$cekBerhasil" != "berhasil"  ]]; do
			echo "$currentTime - ${telkomselNama[$numSimpati]} percobaan ke-$attempt"
			telkomselPaketFx$numSimpati
			cekString=${telkomselPaket:2:6}
			cekString2=${telkomselPaket:49:4}
			cekString3=${telkomselPaket:48:4}

			echo "$currentTime - USSD REPLY : ${yellow}$telkomselPaket${reset}"
			USSDReplyTelkomsel[$numSimpati]="$telkomselPaket"

			if [[ "$cekString" = "Recive"  ]]; then #bila respon open = Recive
				if [[ "$cekString2" != "Maaf" ]] || [[ "$cekString3" != "Maaf" ]]; then
					echo "$currentTime - ${green}${telkomselNama[$numSimpati]} Cek Paket Berhasil...${reset}"
					echo "$currentTime - -------------------------------------------------------------------------------------------------------------"
					telkomselPaket=${telkomselPaket:62:6} #mengambil character yang bernilai jumlah paket
					telkomselPaket=${telkomselPaket//[i: Men dtk]/} #mengabaikan character lain selain angka
					telkomselPaket=$((telkomselPaket + 0)) #merubah variable yang semula string menjadi integer
					echo "$currentTime - ${green}Sisa paket ${telkomselNama[$numSimpati]} : ${telkomselPaket}${reset}"

					if [[ $telkomselPaket -gt 150 ]]; then
						telkomselPaket=0
						telkomselPaket=$((telkomselPaket + 0))
					fi

					sisaPaketTelkomsel[$numSimpati]=${telkomselPaket}
				else
					cekBerhasil="gagal"
					echo "$currentTime - ${red}${telkomselNama[$numSimpati]} Cek Gagal...${reset}"
					echo "----------------------------------------------"
					attempt=$((attempt + 1))
					if [[ $attempt == $maxAttempt ]]; then
						sisaPaketTelkomsel[$numSimpati]=0
					fi
				fi
			else
				cekBerhasil="gagal"
				echo "$currentTime - ${red}${telkomselNama[$numSimpati]} Cek Gagal...${reset}"
				echo "----------------------------------------------"
				attempt=$((attempt + 1))
				if [[ $attempt == $maxAttempt ]]; then
					sisaPaketTelkomsel[$numSimpati]=0
				fi
			fi
		done
	fi
	echo "$currentTime - ${green}+++++++++++++++++++++++ CHECKING PAKET ${telkomselNama[$numSimpati]} FINISHED+++++++++++++++++++++${reset}"

	#===============================================================================
	#memasukan nilai cek paket kedalam database
	#===============================================================================
	echo "INSERT INTO paket (namaProvider, sisaPaket, tanggal, ussdReply) VALUES ('${telkomselNama[$numSimpati]}', '${sisaPaketTelkomsel[$numSimpati]}', '$mysqlDateNow', '${USSDReplyTelkomsel[$numSimpati]}');"| mysql -h$HOST -u$USER -p$PASSWORD dbpulsa

	numSimpati=$((numSimpati + 1))
done

# ==================================================================================================
# XL
# ==================================================================================================
for i in "${XLNo[@]}" #looping sebanyak jumlah variable array
do
	echo "$currentTime - ===================================================================================================="
	echo "$currentTime - Checking Paket ${XLNama[$numXL]}..."
	echo "$currentTime - ===================================================================================================="
	xlPaketFx$numXL
	cekString=${xlPaket:2:6} # mengecek respon dari openvox
	cekString2=${xlPaket:49:4} # mengecek respon dari openvox
	echo "$currentTime - USSD REPLY : ${yellow}$xlPaket${reset}"

	if [[ "$cekString" = "Recive" ]] && [[ "$cekString2" = "Sisa" ]]; then #bila respon open = Recive
		echo "$currentTime - ${green}${XLNama[$numXL]} Cek Paket Berhasil...${reset}"
		echo "$currentTime - -------------------------------------------------------------------------------------------------------------"
		echo "$currentTime - ${green}Sisa Paket : $sisaPaket${reset}"

		sisaPaketXL[$numXL]=$sisaPaket
		USSDReplyXL[$numXL]=$xlPaket
	else
		attempt=1
		attempt=$((attempt + 0))
		cekBerhasil=""
		echo "$currentTime - ${red}${XLNama[$numXL]} Cek Pulsa Gagal...${reset}"
		echo "$currentTime - ----------------------------------------------"
		while [[ $attempt -le $maxAttempt && "$cekBerhasil" != "berhasil"  ]]; do
			echo "$currentTime - ${XLNama[$numXL]} percobaan ke-$attempt"
			xlPaketFx$numXL
			cekString=${xlPaket:2:6} # mengecek respon dari openvox
			cekString2=${xlPaket:49:4} # mengecek respon dari openvox
			echo "$currentTime - USSD REPLY : ${yellow}$xlPaket${reset}"
			USSDReplyXL[$numXL]=$xlPaket

			if [ "$cekString" = "Recive" ] && [ "$cekString2" = "Sisa" ]; then
				echo "$currentTime - ${green}${XLNama[$numXL]} Cek Pulsa Berhasil...${reset}"
				echo "$currentTime - -------------------------------------------------------------------------------------------------------------"
				cekBerhasil="berhasil"
				attempt=$((attempt + 3))
				echo "$currentTime - ${green}Sisa Paket : $sisaPaket${reset}"
				
				sisaPaketXL[$numXL]=$sisaPaket
			else
				cekBerhasil="gagal"
				echo "$currentTime - ${red}${XLNama[$numXL]} Cek Paket Gagal...${reset}"
				echo "$currentTime - ----------------------------------------------"
				
				attempt=$((attempt + 1))
				if [[ $attempt == $maxAttempt ]]; then
					sisaPaketXL[$numXL]=0
				fi
			fi
		done
	fi

	if [[ "${sisaPaketXL[$numXL]}" -le 30 ]] && [[ "${sisaPaketXL[$numXL]}" -gt 0 ]]; then #jika sisa paket kurang dari 30 menit maka paket harus di stop dulu, lalu setelah itu dipasang paket yang baru
		stop${XLNama[$numXL]} #function untuk stop paket
		cekString=${xlStop:2:6} # mengecek respon dari openvox
		cekString2=${xlStop:73:8} # mengecek respon dari openvox
		echo "$currentTime - --------------------------------------------------------------"
		echo "$currentTime - STOP PAKET ${XLNama[$numXL]}"
		echo "$currentTime - --------------------------------------------------------------"
		echo "$currentTime - USSD REPLY : ${yellow}$xlStop${reset}"
		if [[ "$cekString" = "Recive" ]] && [[ "$cekString2" = "Diproses" ]]; then #bila respon open = Recive
			echo "$currentTime - ${green}${XLNama[$numXL]} Stop Paket Berhasil...${reset}"
			echo "$currentTime - -------------------------------------------------------------------------------------------------------------"
			stopPaketStatus[$numXL]="berhasil"
		else
			attempt=1
			attempt=$((attempt + 0))
			cekBerhasil=""
			echo "$currentTime - ${red}${XLNama[$numXL]} Stop Paket Gagal...${reset}"
			echo "$currentTime - ----------------------------------------------"
			while [[ $attempt -le $maxAttempt ]] && [[ "$cekBerhasil" != "berhasil" ]]; do
				echo "$currentTime - ${XLNama[$numXL]} percobaan stop ke-$attempt"
				stop${XLNama[$numXL]} #function untuk stop paket
				cekString=${xlStop:2:6} # mengecek respon dari openvox
				cekString2=${xlStop:73:8} # mengecek respon dari openvox
				echo "$currentTime - --------------------------------------------------------------"
				echo "$currentTime - STOP PAKET"
				echo "$currentTime - --------------------------------------------------------------"
				echo "$currentTime - USSD REPLY : ${yellow}$xlStop${reset}"
				if [[ "$cekString" = "Recive" ]] && [[ "$cekString2" = "Diproses" ]]; then #bila respon open = Recive
					echo "$currentTime - ${green}${XLNama[$numXL]} Stop Paket Berhasil...${reset}"
					echo "$currentTime - -------------------------------------------------------------------------------------------------------------"
					cekBerhasil="berhasil"
					stopPaketStatus[$numXL]="berhasil"
					attempt=$((attempt + 3))
				else
					cekBerhasil="gagal"
					echo "$currentTime - ${red}${XLNama[$numXL]} Stop Paket Gagal...${reset}"
					echo "$currentTime - ----------------------------------------------"
					
					attempt=$((attempt + 1))
					if [[ $attempt == $maxAttempt ]]; then
						stopPaketStatus[$numXL]="gagal"
						# echo "INSERT INTO outbox (DestinationNumber, TextDecoded, CreatorID) VALUES ('$TUKANGKETIK', '${XLNama[$numXL]} Stop Paket Gagal.. USSD REPLY :$xlStop', 'BashAdmin');"| mysql -h$HOST -u$USER -p$PASSWORD sms
						textNotifikasiXL[$numXL]="${XLNama[$numXL]} Stop Paket Gagal.. USSD REPLY :$xlStop"
						curl -X POST -H 'Content-type: application/json' --data '{"text": "```'"$textNotifikasiXL[$numXL]"'```", "channel": "'"$CHANNEL"'", "username": "'"$USERNAME"'", "icon_emoji": "'"$ICONEMOJI2"'"}' https://hooks.slack.com/services/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
					fi
				fi
			done
		fi

		if [[ ${stopPaketStatus[$numXL]} == "berhasil" ]]; then
			
			# ===============================================================================
			# menentukan tanggal baru untuk tanggal habis paket selanjutnya
			# ===============================================================================
			newDate=$(date -d "28 days" +%Y-%m-%d)

			if [[ $numXL -lt 5 ]]; then
				renewalValidation${XLNama[$numXL]}
				validasiString=${validasiPaket:2:6}
				validasiString2=${validasiPaket:75:31}
				echo "$currentTime - --------------------------------------------------------------"
				echo "$currentTime - VALIDASI PAKET ${XLNama[$numXL]}"
				echo "$currentTime - --------------------------------------------------------------"
				echo "$currentTime - USSD REPLY : ${yellow}$validasiPaket${reset}"
				if [[ "$validasiString" == "Recive" ]] && [[ "$validasiString2" == "Kapan Aja 1500Mnt, 30hr, Rp68rb" ]]; then
					echo "$currentTime - ${green}${XLNama[$numXL]} Validasi Paket Oke...${reset}"
					echo "$currentTime - -------------------------------------------------------------------------------------------------------------"
					echo "$currentTime - ${green}Paket yang akan dipasang  : $validasiString2${reset}"

					renewalExec${XLNama[$numXL]}
					renewalString=${xlRenewal:2:6}
					renewalString2=${xlRenewal:73:8}
					echo "$currentTime - --------------------------------------------------------------"
					echo "$currentTime - EKSEKUSI PERPANJANG PAKET ${XLNama[$numXL]}"
					echo "$currentTime - --------------------------------------------------------------"
					echo "$currentTime - USSD REPLY : ${yellow}$xlRenewal${reset}"
					if [[ "$renewalString" = "Recive" ]] && [[ "$renewalString2" = "diproses" ]]; then
						echo "$currentTime - ${green}${XLNama[$numXL]} Perpanjang Paket Berhasil...${reset}"
						echo "$currentTime - -------------------------------------------------------------------------------------------------------------"
						#insert ke database sms untuk ngirim sms notifikasi
						# echo "INSERT INTO outbox (DestinationNumber, TextDecoded, CreatorID) VALUES ('$TUKANGKETIK', '${XLNama[$numXL]} Perpanjang Paket Berhasil.. USSD REPLY : $xlRenewal', 'BashAdmin');"| mysql -h$HOST -u$USER -p$PASSWORD sms
						textNotifikasiXL[$numXL]="${XLNama[$numXL]} Perpanjang Paket Berhasil.. USSD REPLY : $xlRenewal"
						curl -X POST -H 'Content-type: application/json' --data '{"text": "```'"$textNotifikasiXL[$numXL]"'```", "channel": "'"$CHANNEL"'", "username": "'"$USERNAME"'", "icon_emoji": "'"$ICONEMOJI2"'"}' https://hooks.slack.com/services/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
						# ===============================================================================
						# jika berhasil maka tanggal exp date akan diupdate
						# ===============================================================================
						mysql -h1.1.1.200 -uroot -pc3rmat dbpulsa -e "update provider set expDatePaket = '$newDate' where namaProvider = '${XLNama[$numXL]}';"
					else
						attempt=1
						attempt=$((attempt + 0))
						cekBerhasil=""
						echo "$currentTime - ${red}${XLNama[$numXL]} Perpanjang Paket Gagal...${reset}"
						echo "$currentTime - ----------------------------------------------"
						while [[ $attempt -le $maxAttempt ]] && [[ "$cekBerhasil" != "berhasil"  ]]; do
							echo "$currentTime - ${XLNama[$numXL]} percobaan perpanjang paket ke-$attempt"
							renewal${XLNama[$numXL]}
							cekString=${xlRenewalFull:2:6} # mengecek respon dari openvox
							cekString2=${xlRenewalFull:73:8} # mengecek respon dari openvox
							echo "$currentTime - USSD REPLY : ${yellow}$xlPaket${reset}"

							if [ "$cekString" = "Recive" ] && [ "$cekString2" = "diproses" ]; then
								echo "$currentTime - ${green}${XLNama[$numXL]} Perpanjang Paket Berhasil...${reset}"
								echo "$currentTime - -------------------------------------------------------------------------------------------------------------"
								cekBerhasil="berhasil"
								attempt=$((attempt + 3))
								#insert ke database sms untuk ngirim sms notifikasi
								# echo "INSERT INTO outbox (DestinationNumber, TextDecoded, CreatorID) VALUES ('$TUKANGKETIK', '${XLNama[$numXL]} Perpanjang Paket Berhasil.. USSD REPLY : $xlPaket', 'BashAdmin');"| mysql -h$HOST -u$USER -p$PASSWORD sms
								textNotifikasiXL[$numXL]="${XLNama[$numXL]} Perpanjang Paket Berhasil.. USSD REPLY : $xlPaket"
						curl -X POST -H 'Content-type: application/json' --data '{"text": "```'"$textNotifikasiXL[$numXL]"'```", "channel": "'"$CHANNEL"'", "username": "'"$USERNAME"'", "icon_emoji": "'"$ICONEMOJI2"'"}' https://hooks.slack.com/services/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

								# ===============================================================================
								# jika berhasil maka tanggal exp date akan diupdate
								# ===============================================================================
								mysql -h1.1.1.200 -uroot -pc3rmat dbpulsa -e "update provider set expDatePaket = '$newDate' where namaProvider = '${XLNama[$numXL]}';"
							else
								cekBerhasil="gagal"
								echo "$currentTime - ${red}${XLNama[$numXL]} Perpanjang Paket Gagal...${reset}"
								echo "$currentTime - ----------------------------------------------"
								
								attempt=$((attempt + 1))
								if [[ $attempt == $maxAttempt ]]; then
									#insert ke database sms untuk ngirim sms notifikasi
									# echo "INSERT INTO outbox (DestinationNumber, TextDecoded, CreatorID) VALUES ('$TUKANGKETIK', '${XLNama[$numXL]} Perpanjang Paket Gagal.. USSD REPLY : $xlPaket', 'BashAdmin');"| mysql -h$HOST -u$USER -p$PASSWORD sms
									textNotifikasiXL[$numXL]="${XLNama[$numXL]} Perpanjang Paket Gagal.. USSD REPLY : $xlPaket"
						curl -X POST -H 'Content-type: application/json' --data '{"text": "```'"$textNotifikasiXL[$numXL]"'```", "channel": "'"$CHANNEL"'", "username": "'"$USERNAME"'", "icon_emoji": "'"$ICONEMOJI2"'"}' https://hooks.slack.com/services/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
								fi
							fi
						done
					fi
				else
					echo "$currentTime - ${green}${XLNama[$numXL]} Validasi Paket Gagal, Paket yang akan dibeli salah...${reset}"
					echo "$currentTime - -------------------------------------------------------------------------------------------------------------"
					#insert ke database sms untuk ngirim sms notifikasi
					# echo "INSERT INTO outbox (DestinationNumber, TextDecoded, CreatorID) VALUES ('$TUKANGKETIK', '${XLNama[$numXL]} Validasi Paket Gagal,.. Paket yang akan dipasang  : $validasiString2', 'BashAdmin');"| mysql -h$HOST -u$USER -p$PASSWORD sms
					textNotifikasiXL[$numXL]="${XLNama[$numXL]} Validasi Paket Gagal,.. Paket yang akan dipasang  : $validasiString2"
						curl -X POST -H 'Content-type: application/json' --data '{"text": "```'"$textNotifikasiXL[$numXL]"'```", "channel": "'"$CHANNEL"'", "username": "'"$USERNAME"'", "icon_emoji": "'"$ICONEMOJI2"'"}' https://hooks.slack.com/services/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
				fi
			else
				renewalValidation${XLNama[$numXL]}
				validasiString=${validasiPaket:2:6}
				validasiString2=${validasiPaket:64:6}
				echo "$currentTime - --------------------------------------------------------------"
				echo "$currentTime - VALIDASI PAKET ${XLNama[$numXL]}"
				echo "$currentTime - --------------------------------------------------------------"
				echo "$currentTime - USSD REPLY : ${yellow}$validasiPaket${reset}"
				if [[ "$validasiString" = "Recive" ]] && [[ "$validasiString2" = "AnyNet" ]]; then
					echo "$currentTime - ${green}${XLNama[$numXL]} Validasi Paket Oke...${reset}"
					echo "$currentTime - -------------------------------------------------------------------------------------------------------------"
					echo "$currentTime - ${green}Paket yang akan dipasang  : $validasiString2${reset}"

					renewalExec${XLNama[$numXL]}
					renewalString=${xlRenewal:2:6}
					renewalString2=${xlRenewal:72:8}
					echo "$currentTime - --------------------------------------------------------------"
					echo "$currentTime - EKSEKUSI PERPANJANG PAKET ${XLNama[$numXL]}"
					echo "$currentTime - --------------------------------------------------------------"
					echo "$currentTime - USSD REPLY : ${yellow}$xlRenewal${reset}"
					if [[ "$renewalString" = "Recive" ]] && [[ "$renewalString2" = "diproses" ]]; then
						echo "$currentTime - ${green}${XLNama[$numXL]} Perpanjang Paket Berhasil...${reset}"
						echo "$currentTime - -------------------------------------------------------------------------------------------------------------"
						#insert ke database sms untuk ngirim sms notifikasi
						# echo "INSERT INTO outbox (DestinationNumber, TextDecoded, CreatorID) VALUES ('$TUKANGKETIK', '${XLNama[$numXL]} Perpanjang Paket Berhasil.. USSD REPLY : $xlRenewal', 'BashAdmin');"| mysql -h$HOST -u$USER -p$PASSWORD sms
						textNotifikasiXL[$numXL]="${XLNama[$numXL]} Perpanjang Paket Berhasil.. USSD REPLY : $xlRenewal"
						curl -X POST -H 'Content-type: application/json' --data '{"text": "```'"$textNotifikasiXL[$numXL]"'```", "channel": "'"$CHANNEL"'", "username": "'"$USERNAME"'", "icon_emoji": "'"$ICONEMOJI2"'"}' https://hooks.slack.com/services/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
						# ===============================================================================
						# jika berhasil maka tanggal exp date akan diupdate
						# ===============================================================================
						mysql -h1.1.1.200 -uroot -pc3rmat dbpulsa -e "update provider set expDatePaket = '$newDate' where namaProvider = '${XLNama[$numXL]}';"
					else
						attempt=1
						attempt=$((attempt + 0))
						cekBerhasil=""
						echo "$currentTime - ${red}${XLNama[$numXL]} Perpanjang Paket Gagal...${reset}"
						echo "$currentTime - ----------------------------------------------"
						while [[ $attempt -le $maxAttempt ]] && [[ "$cekBerhasil" != "berhasil" ]]; do
							echo "$currentTime - ${XLNama[$numXL]} percobaan perpanjang paket ke-$attempt"
							renewal${XLNama[$numXL]}
							cekString=${xlRenewalFull:2:6} # mengecek respon dari openvox
							cekString2=${xlRenewalFull:72:8} # mengecek respon dari openvox
							echo "$currentTime - USSD REPLY : ${yellow}$xlPaket${reset}"

							if [[ "$cekString" = "Recive" ]] && [[ "$cekString2" = "diproses" ]]; then
								echo "$currentTime - ${green}${XLNama[$numXL]} Perpanjang Paket Berhasil...${reset}"
								echo "$currentTime - -------------------------------------------------------------------------------------------------------------"
								cekBerhasil="berhasil"
								attempt=$((attempt + 3))
								#insert ke database sms untuk ngirim sms notifikasi
								# echo "INSERT INTO outbox (DestinationNumber, TextDecoded, CreatorID) VALUES ('$TUKANGKETIK', '${XLNama[$numXL]} Perpanjang Paket Berhasil.. USSD REPLY : $xlPaket', 'BashAdmin');"| mysql -h$HOST -u$USER -p$PASSWORD sms
								textNotifikasiXL[$numXL]="${XLNama[$numXL]} Perpanjang Paket Berhasil.. USSD REPLY : $xlPaket"
								curl -X POST -H 'Content-type: application/json' --data '{"text": "```'"$textNotifikasiXL[$numXL]"'```", "channel": "'"$CHANNEL"'", "username": "'"$USERNAME"'", "icon_emoji": "'"$ICONEMOJI2"'"}' https://hooks.slack.com/services/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
								# ===============================================================================
								# jika berhasil maka tanggal exp date akan diupdate
								# ===============================================================================
								mysql -h1.1.1.200 -uroot -pc3rmat dbpulsa -e "update provider set expDatePaket = '$newDate' where namaProvider = '${XLNama[$numXL]}';"
							else
								cekBerhasil="gagal"
								echo "$currentTime - ${red}${XLNama[$numXL]} Perpanjang Paket Gagal...${reset}"
								echo "$currentTime - ----------------------------------------------"
								
								attempt=$((attempt + 1))
								if [[ $attempt == $maxAttempt ]]; then
									#insert ke database sms untuk ngirim sms notifikasi
									# echo "INSERT INTO outbox (DestinationNumber, TextDecoded, CreatorID) VALUES ('$TUKANGKETIK', '${XLNama[$numXL]} Perpanjang Paket Gagal.. USSD REPLY : $xlPaket', 'BashAdmin');"| mysql -h$HOST -u$USER -p$PASSWORD sms
									textNotifikasiXL[$numXL]="${XLNama[$numXL]} Perpanjang Paket Gagal.. USSD REPLY : $xlPaket"
									curl -X POST -H 'Content-type: application/json' --data '{"text": "```'"$textNotifikasiXL[$numXL]"'```", "channel": "'"$CHANNEL"'", "username": "'"$USERNAME"'", "icon_emoji": "'"$ICONEMOJI2"'"}' https://hooks.slack.com/services/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
								fi
							fi
						done
					fi
				else
					echo "$currentTime - ${green}${XLNama[$numXL]} Validasi Paket Gagal, Paket yang akan dibeli salah...${reset}"
					echo "$currentTime - -------------------------------------------------------------------------------------------------------------"
					#insert ke database sms untuk ngirim sms notifikasi
					# echo "INSERT INTO outbox (DestinationNumber, TextDecoded, CreatorID) VALUES ('$TUKANGKETIK', '${XLNama[$numXL]} Validasi Paket Gagal,.. Paket yang akan dipasang  : $validasiString2', 'BashAdmin');"| mysql -h$HOST -u$USER -p$PASSWORD sms
					textNotifikasiXL[$numXL]="${XLNama[$numXL]} Validasi Paket Gagal,.. Paket yang akan dipasang  : $validasiString2"
					curl -X POST -H 'Content-type: application/json' --data '{"text": "```'"$textNotifikasiXL[$numXL]"'```", "channel": "'"$CHANNEL"'", "username": "'"$USERNAME"'", "icon_emoji": "'"$ICONEMOJI2"'"}' https://hooks.slack.com/services/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
				fi
			fi
		fi
	fi
	echo "$currentTime - ${yellow}+++++++++++++++++++++++ CHECKING PAKET ${XLNama[$numXL]} FINISHED+++++++++++++++++++++${reset}"



	#===============================================================================
	#memasukan nilai cek pulsa dan paket kedalam database
	#===============================================================================
	echo "INSERT INTO paket (namaProvider, sisaPaket, tanggal, ussdReply) VALUES ('${XLNama[$numXL]}', '${sisaPaketXL[$numXL]}', '$mysqlDateNow', '${USSDReplyXL[$numXL]}');"| mysql -h$HOST -u$USER -p$PASSWORD dbpulsa

	numXL=$((numXL + 1))
done