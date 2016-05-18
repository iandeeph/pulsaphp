<?php
	/**
	* @author ian <christ.lupher@gmail.com>
	* 
	*/
	class trunks
	{
		
		function __construct($host, $span, $today, $user)
		{
			require "sql/connect.php";
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
					$this->caraAktivasi 	= $rowTrunks['caraAktivasi'];
					$this->caraCekKuota 	= $rowTrunks['caraCekKuota'];
					$this->expPaket 		= $rowTrunks['expDatePaket'];
					$this->host 			= $rowTrunks['host'];
					$this->span 			= $rowTrunks['span'];
					$this->conn 			= $conn;
					$this->today 			= $today;
					$this->user 			= $user;
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
				logging($this->today, $this->user, "Update Trunks", $loggingText, $postId);
		        header('Location: ./index.php?menu=setting');
		    }else{
		    	echo "ERROR: Could not able to execute ".$updateQry.". " . mysql_error($this->conn);
		    }
		}
	}
?>