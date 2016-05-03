<div class="container">
	<div class="col s12">
		<h4>Pulsa Cermati Hari Ini</h4>
	</div>
	<div class="col s12">
		<h6>Last Update : <?php echo $lastUpdate;?></h6>
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
						Sisa Pulsa
					</th>
					<th data-filed="sisaPaket">
						Sisa Paket
					</th>
				</tr>
			</thead>
			<tbody>
				<?php
					$no=1;
					$pulsaTodayQry = "";
					$pulsaTodayQry = "SELECT * FROM pulsa WHERE tanggal >= '".$lastDate."'";
					if($resultPulsaToday = mysql_query($pulsaTodayQry)){
					    if (mysql_num_rows($resultPulsaToday) > 0) {
					        while($rowPulsaToday 	= mysql_fetch_array($resultPulsaToday)){
					        	$idPulsa		= $rowPulsaToday['id'];
					        	$namaProvider	= $rowPulsaToday['namaProvider'];
					        	$sisaPulsa		= $rowPulsaToday['sisaPulsa'];
					        	$sisaPaket		= $rowPulsaToday['sisaPaket'];
					        	$tanggal		= $rowPulsaToday['tanggal'];

					        	$pulsaKurang = ($sisaPulsa <= 20000)?"red-text":"";
					        	// $paketKurang = ($sisaPaket <= 60 || $sisaPaket = "-")?"red-text":"";
					        	if ($sisaPaket <= 60 || $sisaPaket == "-") {
					        		$paketKurang = "red-text";
					        	}else{
					        		$paketKurang = "";
					        	}

					        	if ($sisaPaket != "-" && $sisaPaket != "") {
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