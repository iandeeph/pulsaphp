<?php
ini_set('display_errors', '1');
ini_set('error_reporting', E_ALL & ~E_NOTICE);
error_reporting(E_ALL);
ini_set('memory_limit','1G');
set_time_limit(0);
ini_set('max_execution_time', 0); //300 seconds = 5 minutes
require "connconf.php";

date_default_timezone_set("Asia/Jakarta");

function sendToSlack($room, $icon, $username, $message){
    $data       = "payload=" . json_encode(array(         
                  "username"      =>  $username,
                  "channel"       =>  "#{$room}",
                  "text"          =>  $message,
                  "icon_emoji"    =>  $icon
        ));
    $slackHook = "https://hooks.slack.com/services/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";
             
    $c = curl_init();
    curl_setopt($c, CURLOPT_URL, $slackHook);
    curl_setopt($c, CURLOPT_CUSTOMREQUEST, "POST");
    curl_setopt($c, CURLOPT_POSTFIELDS, $data);
    curl_setopt($c, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($c, CURLOPT_SSL_VERIFYPEER, false);
    $result = curl_exec($c);

    return $result;
}

$time_now_start = date("Y-m-d H:i:s", strtotime("-1 minutes"));
$time_now_end = date("Y-m-d H:i:s");

$inboxAgenPulsaQry = "";
$inboxAgenPulsaQry = "SELECT * FROM db_agen_pulsa.inbox WHERE ReceivingDateTime BETWEEN '".$time_now_start."' AND '".$time_now_end."'";
$resultInbox = mysqli_query($conn, $inboxAgenPulsaQry);
if (mysqli_num_rows($resultInbox) > 0) {
    while($rowInbox = mysqli_fetch_array($resultInbox)){
        $inboxTxt   = $rowInbox['TextDecoded'];
        $tanggal    = $rowInbox['ReceivingDateTime'];
        $noPengirim = $rowInbox['SenderNumber'];
        
        $message = "Tanggal : ".$tanggal." \r\n No Pengirim : ".$noPengirim." \r\n Isi Pesan : \r\n ".$inboxTxt."";
        sendToSlack("agenpulsa", ":incoming_envelope:", "Agen Pulsa Inbox", $message);
        echo "scrap inbox";
    }
}else{
    echo "inbox kosong";
};

$sentitemsAgenPulsaQry = "";
$sentitemsAgenPulsaQry = "SELECT * FROM db_agen_pulsa.sentitems WHERE SendingDateTime BETWEEN '".$time_now_start."' AND '".$time_now_end."'";
$resultSentitems = mysqli_query($conn, $sentitemsAgenPulsaQry);
if (mysqli_num_rows($resultSentitems) > 0) {
    while($rowSentitems = mysqli_fetch_array($resultSentitems)){
        $sentTxt        = $rowSentitems['TextDecoded'];
        $tanggalKirim   = $rowSentitems['SendingDateTime'];
        $noPenerima     = $rowSentitems['DestinationNumber'];
        $status         = $rowSentitems['Status'];

        switch ($status){
            case 'SendingOK'        : $status='Sent'    ; $icon=':fire:'; break;
            case 'SendingOKNoReport': $status='Sent'    ; $icon=':fire:'; break;
            case 'SendingError'     : $status='Failed'  ; $icon=':+1:'  ; break;
            case 'DeliveryOK'       : $status='Sent'    ; $icon=':fire:'; break;
            case 'DeliveryFailed'   : $status='Failed'  ; $icon=':+1:'  ; break;
            case 'DeliveryPending'  : $status='Pending' ; $icon=':thinking_face: '; break;
            case 'DeliveryUnknown'  : $status='Failed'  ; $icon=':+1:'  ; break;
            case 'Error'            : $status='Failed'  ; $icon=':+1:'  ; break;
            default                 : $status='Failed'  ; $icon=':+1:'  ; break;
        }
        
        $message = "Tanggal : ".$tanggal." \r\n No Penerima : ".$noPenerima." \r\n Status : ".$status." \r\n Isi Pesan : \r\n ".$sentTxt."";
        sendToSlack("agenpulsa",$icon, "Agen Pulsa Sentitems", $message);
        echo "scrap sentitems";
    }
}else{
    echo "sentitems kosong";
};