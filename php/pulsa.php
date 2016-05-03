<?php
$menu = (isset($_GET['menu']))?isset($_GET['menu']):"";

foreach($_POST as $key => $val) {
    if (!is_array($val)) {
        $_POST[$key] = mysql_real_escape_string($val);
    }
}

function alertBox($msg) {
    echo '<script type="text/javascript">alert("' . $msg . '")</script>';
}

$today=date("Y-m-d 00:00:00");

$currentMonthYear   = date("Y-m");

$postDate = (isset($_POST['bulanTahun']))?strval($_POST['bulanTahun']):$currentMonthYear;

$postMonth  = date("m", strtotime($postDate));
$postYear   = date("Y", strtotime($postDate));

$daycount=cal_days_in_month(CAL_GREGORIAN,$postMonth,$postYear);

function phone_number($phone) {
    $firstDash = substr_replace($phone, "-", 4, 0);
    $secondDash = substr_replace($firstDash, "-", 9, 0);
    return $secondDash;
}

$lastUpdateQry = "";
$lastUpdateQry = "SELECT DATE_FORMAT(max(tanggal), '%d %b %y - %H:%i') as lastUpdate, DATE_FORMAT(max(tanggal), '%Y-%m-%d %H:%i:00') as lastDate FROM pulsa LIMIT 1";
if($resultLastUpdate = mysql_query($lastUpdateQry)){
    if (mysql_num_rows($resultLastUpdate) > 0) {
        $rowLastUpdate 	= mysql_fetch_array($resultLastUpdate);
    	$lastUpdate	= $rowLastUpdate['lastUpdate'];
    	$lastDate	= $rowLastUpdate['lastDate'];
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

$providerQry = "";
$providerQry = "SELECT * FROM provider";
if($resultProvider = mysql_query($providerQry)){
    if (mysql_num_rows($resultProvider) > 0) {
        while($rowProvider 	= mysql_fetch_array($resultProvider)){
        	$idProvider[]	= $rowProvider['idProvider'];
            $namaProvider[]   = $rowProvider['namaProvider'];
        	$namaProvider[$rowProvider['idProvider']]	= $rowProvider['namaProvider'];
        	$noProvider[$rowProvider['namaProvider']]	= $rowProvider['noProvider'];
        	$namaPaket[$rowProvider['namaProvider']]	= $rowProvider['namaPaket'];
        	$caraAktivasi[$rowProvider['namaProvider']]	= $rowProvider['caraAktivasi'];
        	$caraCekKuota[$rowProvider['namaProvider']]	= $rowProvider['caraCekKuota'];
        	$expPaket[$rowProvider['namaProvider']]		= $rowProvider['expDatePaket'];
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