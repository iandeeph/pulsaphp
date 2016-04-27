<?php
$menu = (isset($_GET['menu']))?isset($_GET['menu']):"";

foreach($_POST as $key => $val) {
	if (!is_array($val)) {
		$_POST[$key] = mysql_real_escape_string($val);
	}
}

$today=date("Y-m-d 00:00:00");

$lastUpdateQry = "";
$lastUpdateQry = "SELECT DATE_FORMAT(max(tanggal), '%d %b %y - %h:%i') as lastUpdate, max(tanggal) as lastDate  FROM pulsa LIMIT 1";
if($resultLastUpdate = mysql_query($lastUpdateQry)){
    if (mysql_num_rows($resultLastUpdate) > 0) {
        $rowLastUpdate 	= mysql_fetch_array($resultLastUpdate);
        	$lastUpdate	= $rowLastUpdate['lastUpdate'];
        	$lastDate	= $rowLastUpdate['lastDate'];
    }
}

$providerQry = "";
$providerQry = "SELECT * FROM provider";
if($resultProvider = mysql_query($providerQry)){
    if (mysql_num_rows($resultProvider) > 0) {
        while($rowProvider 	= mysql_fetch_array($resultProvider)){
        	$idProvider[]	= $rowProvider['idProvider'];
        	$namaProvider[]	= $rowProvider['namaProvider'];
        	$noProvider[]	= $rowProvider['noProvider'];
        	$namaPaket[]	= $rowProvider['namaPaket'];
        	$caraAktivasi[]	= $rowProvider['caraAktivasi'];
        	$caraCekKuota[]	= $rowProvider['caraCekKuota'];
        	$expPaket[]		= $rowProvider['expDatePaket'];
        }
    }
}
?>