<?php
ini_set('display_errors', '1');
ini_set('error_reporting', E_ALL & ~E_NOTICE);
error_reporting(E_ALL);
ini_set('memory_limit','1G');
set_time_limit(0);
ini_set('max_execution_time', 0); //300 seconds = 5 minutes
require "connconf.php";

date_default_timezone_set("Asia/Jakarta");

//the name of the curl function
function curl_get_contents($url){

    //Initiate the curl
    $ch=curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    //removes the header of the webpage
    curl_setopt($ch, CURLOPT_HEADER, 0);
    //do not display the whole page
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    //insert openvox password
    curl_setopt($ch, CURLOPT_USERPWD, "admin:c3rmat");
    //execute the curl
    $output = curl_exec($ch);
    //close the curl so that resources are not wasted
    //curl_close($ch);
    return $output;
}

function sendToSlack($message){
    $room = "cermati_pulsa"; 
    $icon = ":pikapika:"; 
    $data = "payload=" . json_encode(array(         
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

$time_now_start = date("Y/m/d%20H:i:s", strtotime("-15 minutes"));
$time_now_end = date("Y/m/d%20H:i:s");

$itemPerPages = 1;

$namaProvider = array("ThreeAll1","ThreeAll2","ThreeAll3","ThreeAll4","ThreeAll5","ThreeAll6","ThreeAll7","ThreeAll8","ThreeAll9","ThreeAll10","ThreeAll11","ThreeAll12","ThreeAll13","ThreeAll14","ThreeAll15","ThreeAll16","ThreeAll17","ThreeAll18","ThreeAll19","ThreeAll20","ThreeAll21","ThreeAll22","ThreeAll23","ThreeAll24","ThreeAll25","ThreeAll26","ThreeAll27","ThreeAll28","ThreeAll29","ThreeAll30","ThreeAll31","ThreeAll32","ThreeAll33","ThreeAll34","ThreeAll35","ThreeAll36","ThreeAll37","ThreeAll38","ThreeAll39","ThreeAll40");

$data = array();

$inserts = array();
// looping untuk setiap IP openvox
$numNamaProvider = 0;

$providerQry = "";
$providerQry = "SELECT * FROM provider WHERE namaProvider LIKE 'ThreeAll%' ORDER BY length(namaProvider), namaProvider";
if($resultProvider = mysqli_query($conn, $providerQry)){
    if (mysqli_num_rows($resultProvider) > 0) {
        $rowProvider = mysqli_fetch_array($resultProvider);
        $namaProvider   = $rowProvider['namaProvider'];
        $noProvider     = $rowProvider['noProvider'];
        $host           = $rowProvider['host'];
        $span           = $rowProvider['span'];
        
        //set url untuk inbox pada openvox
        $url = "http://".$host."/cgi-bin/php/sms-inbox.php?current_page=1&port_filter=gsm-".$port."&phone_number_filter=3&start_datetime_filter=".$time_now_start."&end_datetime_filter=".$time_now_end."&message_filter=Sisa&";
        echo $url."\n";
        $output = curl_get_contents($url);

        $dom = new DOMDocument();
        $dom->preserveWhiteSpace = false;
        $dom->formatOutput       = true;
        $dom->loadHTML($output);
        $body = $dom->getElementById("mainform");
        $tr = $body->getElementsByTagName('tr');
        if($tr->length > 0){
            $row = 0;
            $data[$row] = array();
            //menentukan selector untuk data yang akan diambil

            foreach ($body->getElementsByTagName('tr') as $tr) {
                $col = 0;
                foreach ($tr->getElementsByTagName('td') as $td) {
                    $data[$row][$col] = $td;

                    $col++;
                }
                $row++;
            }
            //looping sebanyak jumlah item perhalaman
            for($item = 1; $item <= $itemPerPages; $item++){
                $packetRest     = preg_replace("/[A-Za-z]/", "", substr($msg, 24, 3));
                $phone          = trim($data[$item][2]->nodeValue);
                $date           = trim($data[$item][3]->nodeValue);
                $msg            = trim($data[$item][4]->nodeValue);

                echo "iserting\n";
                $inserts[] = "(
                    '".$namaProvider."',
                    '".$packetRest."',
                    '".str_replace('/', '-', $date)."',
                    '".mysql_real_escape_string($msg)."'
                    )";
                if (intval($packetRest) <= 20) {
                    $message = "$namaProvider sisa paket kurang dari 20 menit.. @ian tolong diisi paket..!!! code : `AN30.".$noProvider.".0312` terima kasihh...."
                    sendToSlack($message);
                }
                
            }
        }else{
            echo "kosong\n";
        }
        $numNamaProvider++;
    }
}

if (count($inserts) > 0) {
    echo "inserting to db..";
    $insertToDB = "INSERT INTO paket (namaProvider, sisaPaket, tanggal, ussdReply) VALUES ".implode($inserts, ',');
    if (!mysql_query($insertToDB)) {
        echo "Error: ".mysql_error($conn);
    }
} else {
    echo 'Nothing';
}