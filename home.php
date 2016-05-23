<div class="container">
	<div class="col s12">
		<h4>Pulsa Cermati Hari Ini</h4>
	</div>
	<div class="col s12 hide-on-large-only">
		<span class="font-15">Pulsa Last Update : <?php echo $lastUpdate;?></span> 
	</div>
	<div class="col s12 hide-on-large-only">
		<span class="font-15">Paket Last Update : <?php echo $lastUpdatePaket;?></span> 
	</div>
	<div class="col s12 mt-30 mb-20 home-table">
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
						<span class="font-15"></span><span class="hide-on-med-and-down">(<?php echo $lastUpdate;?>)</span>
					</th>
					<th data-filed="sisaPaket">
						Sisa Paket <br>
						<span class="font-15"></span><span class="hide-on-med-and-down">(<?php echo $lastUpdatePaket;?>)</span>
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

					        	$trunk = new trunks;
					        	$trunk = $trunk->getTrunksByName($namaProvider);

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
										<td>
											<?php echo parsePulsa($sisaPulsa, $trunk->hargaPaket); ?>
										</td>
										<td>
											<?php echo parsePulsa($sisaPaket, 30); ?>
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
		<a href="./index.php?menu=pulsa" class="btn waves-effect waves-light blue-cermati" name="action">More
			<i class="material-icons right">send</i>
		</a>
	</div>
</div>