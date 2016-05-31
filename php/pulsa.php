<?php
$menu = (isset($_GET['menu']))?$_GET['menu']:"";
$name = (isset($_SESSION['name']))?$_SESSION['name']:"";

foreach($_POST as $key => $val) {
    if (!is_array($val)) {
        $_POST[$key] = mysql_real_escape_string($val);
    }
}

$jamCekPaket = array(
    "08:15",
    "08:45",
    "09:15",
    "09:45",
    "10:15",
    "10:45",
    "11:15",
    "11:45",
    "13:15",
    "13:45",
    "14:15",
    "14:45",
    "15:15",
    "15:45",
    "16:15",
    "16:45"
);

function alertBox($msg) {
    echo '<script type="text/javascript">alert("' . $msg . '")</script>';
}

function parsePulsa($pulsa, $hargaPaket){
    // $pulsa = floatval($pulsa);
    if($pulsa != NULL && $pulsa != '' && $pulsa != "0"){
        if ($pulsa >= 999999) {
            $pulsaAkhir = "<span class='red-text'>fail</span>";
        } else {
            $pulsaAkhir = ($pulsa < $hargaPaket)?"<span class='red-text'>".number_format($pulsa, 0, ',', '.')."</span>":number_format($pulsa, 0, ',', '.')       ;
        }
    }else{
        $pulsaAkhir = "-";
    }

    return $pulsaAkhir;
}

function logging($date, $user, $action, $value, $iditem){
    require "sql/connect.php";
    $insertLogQry = "";
    $insertLogQry = "INSERT INTO log (date, user, action, value, iditem) VALUES ('".$date."', '".$user."', '".$action."', '".$value."', '".$iditem."')";
    if(!mysql_query($insertLogQry)){
        alertBox("ERROR: Could not able to execute " . mysql_error($conn));
    }
}

function phone_number($phone) {
    $firstDash = substr_replace($phone, "-", 4, 0);
    $secondDash = substr_replace($firstDash, "-", 9, 0);
    return $secondDash;
}

function getJamPaket($date, $index = NULL) {
    $jamCekPulsa = array();
    if (strtotime($date) >= strtotime("2016-05-11")) {
        $jamCekPulsa = array(
            "05:15",
            "12:15",
            "17:15"
        );
    } else {
        $jamCekPulsa = array(
            "05:10",
            "12:10",
            "17:10"
        );
    }

    if ($index === NULL) {
        return $jamCekPulsa;
    } else {
        return $jamCekPulsa[$index];
    }
}
$today=date("Y-m-d 00:00:00");

$currentMonthYear   = date("Y-m");

$postDate = (isset($_POST['bulanTahun']))?strval($_POST['bulanTahun']):$currentMonthYear;


$postMonth  = date("m", strtotime($postDate."-01"));
$postYear   = date("Y", strtotime($postDate."-01"));

$daycount=cal_days_in_month(CAL_GREGORIAN,$postMonth,$postYear);


$lastUpdateQry = "";
$lastUpdateQry = "SELECT DATE_FORMAT(max(tanggal), '%d %b %y - %H:%i') as lastUpdate, DATE_FORMAT(max(tanggal), '%Y-%m-%d %H:%i:00') as lastDate FROM pulsa LIMIT 1";
if($resultLastUpdate = mysql_query($lastUpdateQry)){
    if (mysql_num_rows($resultLastUpdate) > 0) {
        $rowLastUpdate 	= mysql_fetch_array($resultLastUpdate);
    	$lastUpdate	= $rowLastUpdate['lastUpdate'];
    	$lastDate	= $rowLastUpdate['lastDate'];
    }
}

$lastUpdatePaketQry = "";
$lastUpdatePaketQry = "SELECT DATE_FORMAT(max(tanggal), '%d %b %y - %H:%i') as lastUpdatePaket, DATE_FORMAT(max(tanggal), '%Y-%m-%d %H:%i:00') as lastDatePaket FROM paket LIMIT 1";
if($resultLastUpdatePaket = mysql_query($lastUpdatePaketQry)){
    if (mysql_num_rows($resultLastUpdatePaket) > 0) {
        $rowLastUpdatePaket  = mysql_fetch_array($resultLastUpdatePaket);
        $lastUpdatePaket = $rowLastUpdatePaket['lastUpdatePaket'];
        $lastDatePaket   = $rowLastUpdatePaket['lastDatePaket'];
    }
}

$monthQry = "";
$monthQry = "SELECT DATE_FORMAT(tanggal, '%b %y') as monthYear, DATE_FORMAT(tanggal, '%Y-%m') as allDate FROM pulsa WHERE (tanggal IS NOT NULL OR tanggal != '') GROUP BY monthYear";
if($resultMonth = mysql_query($monthQry)){
    if (mysql_num_rows($resultMonth) > 0) {
        while($rowMonth  = mysql_fetch_array($resultMonth)){
            $monthYear[] = $rowMonth['monthYear'];
            $allDate[] = $rowMonth['allDate'];
        }
    }
}

$monthPaketQry = "";
$monthPaketQry = "SELECT DATE_FORMAT(tanggal, '%b %y') as monthYear, DATE_FORMAT(tanggal, '%Y-%m') as allDate FROM paket WHERE (tanggal IS NOT NULL OR tanggal != '') GROUP BY monthYear";
if($resultMonthPaket = mysql_query($monthPaketQry)){
    if (mysql_num_rows($resultMonthPaket) > 0) {
        while($rowMonthPaket  = mysql_fetch_array($resultMonthPaket)){
            $monthYearPaket[] = $rowMonthPaket['monthYear'];
            $allDatePaket[] = $rowMonthPaket['allDate'];
        }
    }
}

$providerQry = "";
$providerQry = "SELECT * FROM provider";
if($resultProvider = mysql_query($providerQry)){
    if (mysql_num_rows($resultProvider) > 0) {
        while($rowProvider 	= mysql_fetch_array($resultProvider)){
        	$idProvider[]	= $rowProvider['idProvider'];
            // $namaProvider[]   = $rowProvider['namaProvider'];
        	$namaProvider[$rowProvider['idProvider']]	= $rowProvider['namaProvider'];
        	$noProvider[$rowProvider['namaProvider']]	= $rowProvider['noProvider'];
            $namaPaket[$rowProvider['namaProvider']]    = $rowProvider['namaPaket'];
        	$hargaPaket[$rowProvider['namaProvider']]	= $rowProvider['hargaPaket'];
        	$caraAktivasi[$rowProvider['namaProvider']]	= $rowProvider['caraAktivasi'];
        	$caraCekKuota[$rowProvider['namaProvider']]	= $rowProvider['caraCekKuota'];
            $expPaket[$rowProvider['namaProvider']]     = $rowProvider['expDatePaket'];
            $host[]                                     = $rowProvider['host'];
        	$span[$rowProvider['host']]                 = $rowProvider['span'];
        }
    }
}


$spans = array();
$hostQry = "";
$hostQry = "SELECT * FROM provider ORDER BY host, span";
if($resultHost = mysql_query($hostQry)){
    if (mysql_num_rows($resultHost) > 0) {
        while($rowHost  = mysql_fetch_array($resultHost)){
            if (!isset($spans[$rowHost['host']])) {
                $spans[$rowHost['host']] = array();
            }

            $spans[$rowHost['host']][] = $rowHost;
        }
    }
}

// ==============================================================================================================================
// -------------------------------------------------- LOGIN ----------------------------------------------
// ==============================================================================================================================

if(isset($_POST['btnLogin'])){
    $postUsername = $_POST['loginUsername'];
    $postPassword = $_POST['loginPassword'];

    $loginQry = "SELECT * FROM admin WHERE username = '".$postUsername."' AND password = '".$postPassword."' LIMIT 1";
    if($resultLogin = mysql_query($loginQry)){
        if (mysql_num_rows($resultLogin) != 0) {
            $rowLogin = mysql_fetch_array($resultLogin);
            $_SESSION['login']      = 'logged';
            $_SESSION['name']       = $rowLogin['name'];
            $_SESSION['privilege']  = $rowLogin['privilege'];
            $_SESSION['idadmin']    = $rowLogin['idadmin'];
            $_SESSION['username']   = $rowLogin['username'];

            header('Location: ./');
        }else{
            $_SESSION['login']  = 'notlogged';
            alertBox('Username atau Password Salah..');
        }
    }
}
?>