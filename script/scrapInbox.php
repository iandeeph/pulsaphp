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

$time_now_start = date("Y/m/d%20H:i:s", strtotime("-15 minutes"));
$time_now_end = date("Y/m/d%20H:i:s");

$itemPerPages = 1;
$ipOpenVox = array(
    "3.3.3.4", 
    "3.3.3.5", 
    "3.3.3.6",
    "3.3.3.7", 
    "3.3.3.8", 
    "3.3.3.9", 
    "3.3.3.10", 
    "3.3.3.11"
    );
$portOpenVox = array(
    "gsm-1",
    "gsm-2",
    "gsm-3",
    "gsm-4"
    );

$namaProvider = array("ThreeAll1","ThreeAll2","ThreeAll3","ThreeAll4","ThreeAll5","ThreeAll6","ThreeAll7","ThreeAll8","ThreeAll9","ThreeAll10","ThreeAll11","ThreeAll12","ThreeAll13","ThreeAll14","ThreeAll15","ThreeAll16","ThreeAll17","ThreeAll18","ThreeAll19","ThreeAll20","ThreeAll21","ThreeAll22","ThreeAll23","ThreeAll24","ThreeAll25","ThreeAll26","ThreeAll27","ThreeAll28","ThreeAll29","ThreeAll30","ThreeAll31","ThreeAll32");

$data = array();

$inserts = array();
// looping untuk setiap IP openvox
$numNamaProvider = 0;
foreach ($ipOpenVox as $ip) {
    foreach ($portOpenVox as $port) {
        //set url untuk inbox pada openvox
        $url = "http://".$ip."/cgi-bin/php/sms-inbox.php?current_page=1&port_filter=".$port."&phone_number_filter=3&start_datetime_filter=".$time_now_start."&end_datetime_filter=".$time_now_end."&message_filter=Sisa&";
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
                $phone  = trim($data[$item][2]->nodeValue);
                $date   = trim($data[$item][3]->nodeValue);
                $msg    = trim($data[$item][4]->nodeValue);

                echo "iserting\n";
                $inserts[] = "(
                    '".$namaProvider[$numNamaProvider]."',
                    '".preg_replace("/[A-Za-z]/", "", substr($msg, 24, 3))."',
                    '".str_replace('/', '-', $date)."',
                    '".mysql_real_escape_string($msg)."'
                    )";
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