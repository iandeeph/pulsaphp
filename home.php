<div class="container">
	<div class="col s12">
		<h4>Pulsa Cermati Hari Ini</h4>
	</div>
	<div id="home-table" class="col s12 mt-30 mb-20">
		<table class="bordered">
			<thead>
				<tr>
					<th data-filed="no">
						No.
					</th>
					<th data-filed="provider">
						Provider
					</th>
					<th data-filed="noHP">
						Nomor
					</th>
					<th data-filed="sisaPulsa">
						Sisa Pulsa <br>
						<span class="font-15">(<?php echo $lastUpdate;?>)</span>
					</th>
					<th data-filed="sisaPaket">
						Sisa Paket <br>
						<span class="font-15">(<?php echo $lastUpdatePaket;?>)</span>
					</th>
				</tr>
			</thead>
			<tbody>
				<?php
					$no=1;
					$pulsaTodayQry = "";
					$pulsaTodayQry = "SELECT * FROM pulsa WHERE tanggal >= '".$lastDate."' ORDER BY namaProvider";
					if($resultPulsaToday = mysql_query($pulsaTodayQry)){
					    if (mysql_num_rows($resultPulsaToday) > 0) {
					        while($rowPulsaToday 	= mysql_fetch_array($resultPulsaToday)){
					        	$idPulsa		= $rowPulsaToday['id'];
					        	$namaProvider	= $rowPulsaToday['namaProvider'];
					        	$sisaPulsa		= $rowPulsaToday['sisaPulsa'];
					        	$tanggal		= $rowPulsaToday['tanggal'];

					        	$LatestPaketQry = "";
								$LatestPaketQry = "SELECT sisaPaket FROM paket WHERE namaProvider = '".$namaProvider."' AND tanggal >= '".$lastDatePaket."' LIMIT 1";
								if($resultLatestPaket = mysql_query($LatestPaketQry)){
								    if (mysql_num_rows($resultLatestPaket) > 0) {
								        $rowPaket 	= mysql_fetch_array($resultLatestPaket);
										$sisaPaket = $rowPaket['sisaPaket'];
									}else{
										$sisaPaket = "-";
									}
								}

					        	$pulsaKurang = ($sisaPulsa <= $hargaPaket[$namaProvider])?"red-text":"";
					        	// $paketKurang = ($sisaPaket <= 60 || $sisaPaket = "-")?"red-text":"";
					        	if ($sisaPaket <= 60 || $sisaPaket == "-") {
					        		$paketKurang = "red-text";
					        	}else{
					        		$paketKurang = "";
					        	}

					        	if ($sisaPaket != "-" && $sisaPaket != "" && $sisaPaket != NULL) {
					        		$sisaPaket = number_format($sisaPaket, 0, ',', '.')." Menit";
					        	}else{
					        		$sisaPaket = "gagal cek";
					        	}

					        	?>
									<tr>
										<td>
											<?php echo $no; ?>
										</td>
										<td>
											<?php echo $namaProvider; ?>
										</td>
										<td>
											<?php
												if(isset($noProvider[$namaProvider])){
													echo phone_number($noProvider[$namaProvider]);
												}else{
													echo "";
												}
											;?>
										</td>
										<td class="<?php echo $pulsaKurang;?>">
											<?php echo number_format($sisaPulsa, 0, ',', '.'); ?>
										</td>
										<td class="<?php echo $paketKurang;?>">
											<?php echo $sisaPaket; ?>
										</td>
									</tr>
								<?php
								$no++;
					        }
					    }
					}
				?>
			</tbody>
		</table>
	</div>
	<div class="col s12">
		<a href="./index.php?menu=perdates" class="btn waves-effect waves-light blue-cermati" name="action">More
			<i class="material-icons right">send</i>
		</a>
	</div>
</div>