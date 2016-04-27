<div class="container">
	<div class="col s12">
		<h4>Pulsa Cermati Hari Ini</h4>
	</div>
	<div class="col s12">
		<h6>Last Update : <?php echo $lastUpdate;?></h6>
	</div>
	<div class="col s12 mt-30">
		<table class="width-half striped">
			<thead>
				<tr>
					<th width="10%" data-filed="no">
						No.
					</th>
					<th width="45%" data-filed="provider">
						Provider
					</th>
					<th width="45%" data-filed="sisaPulsa">
						Sisa Pulsa
					</th>
				</tr>
			</thead>
			<tbody>
				<?php
					$no=1;
					$pulsaTodayQry = "";
					$pulsaTodayQry = "SELECT * FROM pulsa WHERE tanggal = '".$lastDate."'";
					if($resultPulsaToday = mysql_query($pulsaTodayQry)){
					    if (mysql_num_rows($resultPulsaToday) > 0) {
					        while($rowPulsaToday 	= mysql_fetch_array($resultPulsaToday)){
					        	$idPulsa		= $rowPulsaToday['id'];
					        	$namaProvider	= $rowPulsaToday['namaProvider'];
					        	$sisaPulsa		= $rowPulsaToday['sisaPulsa'];
					        	$tanggal		= $rowPulsaToday['tanggal'];

					        	$textColor = ($sisaPulsa <= 20000)?"red-text":"";
					        	?>
									<tr>
										<td>
											<?php echo $no; ?>
										</td>
										<td>
											<?php echo $namaProvider; ?>
										</td>
										<td class="<?php echo $textColor;?>">
											<?php echo number_format($sisaPulsa, 0, ',', '.'); ?>
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
</div>