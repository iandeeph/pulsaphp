<?php
	/**
	* @author ian <christ.lupher@gmail.com>
	* 
	*/
	Class trunks
	{
		
		function __construct()
		{
			$today=date("Y-m-d 00:00:00");
			$name = (isset($_SESSION['name']))?$_SESSION['name']:"";
			require "sql/connect.php";
		}

		function getTrunkByHostAndSpan($host, $span)
		{
			$trunksQry = "";
			$trunksQry = "SELECT * FROM provider WHERE host like '".$host."' AND span = '".$span."' LIMIT 1";
			if($resultTrunks = mysql_query($trunksQry)){
				if (mysql_num_rows($resultTrunks) > 0) {
					return mysql_fetch_array($resultTrunks);
			    }
			}
		}

		function getTrunksByName($trunksName)
		{
			$trunksQry = "";
			$trunksQry = "SELECT * FROM provider WHERE namaProvider = '".$trunksName."' LIMIT 1";
			if($resultTrunks = mysql_query($trunksQry)){
				if (mysql_num_rows($resultTrunks) > 0) {
					return mysql_fetch_array($resultTrunks);
					
			    }
			}
		}

		function submit($postId, $postNamaProvider, $postNomorProvider, $postNamaPaket, $postHargaPaket, $postCaraAktivasi, $postCaraCekKuota, $postExpDatePaket){
			$updateQry = "UPDATE provider SET 
						namaProvider = '".$postNamaProvider."',
						noProvider = '".$postNomorProvider."',
						namaPaket = '".$postNamaPaket."',
						hargaPaket = '".$postHargaPaket."',
						caraAktivasi = '".$postCaraAktivasi."',
						caraCekKuota = '".$postCaraCekKuota."',
						expDatePaket = '".$postExpDatePaket."'
						WHERE idProvider = '".$postId."'";

			$loggingText = "OLD DATA
							---------------------------------------
							Nama Provider	: ".$this->name."
							No. Provider 	: ".$this->no."
							Nama Paket 		: ".$this->namaPaket."
							Harga Paket 	: ".$this->hargaPaket."
							Cara Aktivasi	: ".$this->caraAktivasi."
							Cara Cek Kuota 	: ".$this->caraCekKuota."
							Exp. Date Paket	: ".$this->expPaket."

							NEW DATA
							----------------------------------------
							Nama Provider	: ".$postNamaProvider."
							No. Provider 	: ".$postNomorProvider."
							Nama Paket 		: ".$postNamaPaket."
							Harga Paket 	: ".$postHargaPaket."
							Cara Aktivasi	: ".$postCaraAktivasi."
							Cara Cek Kuota 	: ".$postCaraCekKuota."
							Exp. Date Paket	: ".$postExpDatePaket."
							";

			if(mysql_query($updateQry)){
				logging($today, $user, "Update Trunks", $loggingText, $postId);
		        // header('Location: ./index.php?menu=setting');
		    }else{
		    	echo "ERROR: Could not able to execute ".$updateQry.". " . mysql_error($conn);
		    }
		}


	}
?>