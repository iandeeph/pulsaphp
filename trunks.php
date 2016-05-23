<?php
	/**
	* @author ian <christ.lupher@gmail.com>
	* 
	*/
	class trunks
	{
		
		function __construct()
		{
			$today=date("Y-m-d 00:00:00");
			$name = (isset($_SESSION['name']))?$_SESSION['name']:"";
			require "sql/connect.php";
		}

		function getTrunksBySpanAndHost($host, $span)
		{
			$trunksQry = "";
			$trunksQry = "SELECT * FROM provider WHERE host = '".$host."' AND span = '".$span."' LIMIT 1";
			if($resultTrunks = mysql_query($trunksQry)){
				if (mysql_num_rows($resultTrunks) > 0) {
					$rowTrunks = mysql_fetch_array($resultTrunks);
					$idProvider = $rowTrunks['idProvider'];
					// $namaProvider[]   = $rowProvider['namaProvider'];
					$this->id 				= $rowTrunks['idProvider'];
					$this->name 			= $rowTrunks['namaProvider'];
					$this->no 				= $rowTrunks['noProvider'];
					$this->namaPaket 		= $rowTrunks['namaPaket'];
					$this->hargaPaket 		= $rowTrunks['hargaPaket'];
					$this->caraCekPulsa 	= $rowTrunks['caraCekPulsa'];
					$this->caraAktivasi 	= $rowTrunks['caraAktivasi'];
					$this->caraCekKuota 	= $rowTrunks['caraCekKuota'];
					$this->caraStopPaket 	= $rowTrunks['caraStopPaket'];
					$this->expPaket 		= $rowTrunks['expDatePaket'];
					$this->host 			= $rowTrunks['host'];
					$this->span 			= $rowTrunks['span'];
			    }
			}
		}

		function getTrunksByName($trunksName)
		{
			$trunksQry = "";
			$trunksQry = "SELECT * FROM provider WHERE namaProvider = '".$trunksName."' LIMIT 1";
			if($resultTrunks = mysql_query($trunksQry)){
				if (mysql_num_rows($resultTrunks) > 0) {
					$rowTrunks = mysql_fetch_array($resultTrunks);
					$idProvider = $rowTrunks['idProvider'];
					// $namaProvider[]   = $rowProvider['namaProvider'];
					$this->id 				= $rowTrunks['idProvider'];
					$this->name 			= $rowTrunks['namaProvider'];
					$this->no 				= $rowTrunks['noProvider'];
					$this->namaPaket 		= $rowTrunks['namaPaket'];
					$this->hargaPaket 		= $rowTrunks['hargaPaket'];
					$this->caraCekPulsa 	= $rowTrunks['caraCekPulsa'];
					$this->caraAktivasi 	= $rowTrunks['caraAktivasi'];
					$this->caraCekKuota 	= $rowTrunks['caraCekKuota'];
					$this->caraStopPaket 	= $rowTrunks['caraStopPaket'];
					$this->expPaket 		= $rowTrunks['expDatePaket'];
					$this->host 			= $rowTrunks['host'];
					$this->span 			= $rowTrunks['span'];
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
		        header('Location: ./index.php?menu=setting');
		    }else{
		    	echo "ERROR: Could not able to execute ".$updateQry.". " . mysql_error($conn);
		    }
		}


	}
?>