<div class="container">
	<div class="col s12">
		<h4>Sisa Pulsa Cermati</h4>
	</div>
	<div class="col s12">
		<h5>Periode :</h5>
		<form id="simulation-form" action="#" method="post">
			<div class="grouped-input fixed">
				<select class="form-control" name="bulanTahun" id="bulanTahun">
					<?php
						for ($i=0; $i < count($monthYear); $i++) {
							$selected = ($allDate[$i] == $postDate)?"selected":"";
							echo '<option value="'.$allDate[$i].'" '.$selected.'>'.$monthYear[$i].'</option>';
						}
					?>
				</select>
			</div>
		</form>
    </div>
	<div id="simulation-table" class="mt-30">
		<div class="col s2">
			<table class="bordered">
				<thead>
					<tr class="border-bottom">
						<th data-filed="tanggal" class="border-right" colspan="2">
							Tanggal
						</th>
						<?php
							for ($i=1; $i <= count($idProvider) ; $i++) {
								?>
									<th data-filed="trunks" colspan="2">
										<?php echo $namaProvider[$i]; ?>
									</th>
								<?php
							}
						?>
					</tr>
				</thead>
				<tbody>
					<?php
						for ($i=1; $i <= $daycount ; $i++) {
							?>
								<tr>
									<td rowspan="3" style="text-align: center;" id="<?php echo 'tanggal'.$i;?>">
										<?php echo $i;?>
									</td>
									<?php
										for ($j=1 ;$j <= count($idProvider); $j++) {
											?>
												<td class="bold">
													<?php
														$qryTanggal = $postDate."-".sprintf("%02d", $i);
														$currBalQry = "";
														$currBalQry = "SELECT sisaPulsa, sisaPaket FROM pulsa WHERE namaProvider = '".$namaProvider[$j]."' AND date_format(tanggal, '%Y-%m-%d')='".$qryTanggal."'";
														if($resultCurBal = mysql_query($currBalQry)){
															if (mysql_num_rows($resultCurBal) > 0) {
																while($rowCurBall = mysql_fetch_array($resultCurBal)){
																	$pulsa	= $rowCurBall['sisaPulsa'];
																	$paket 	= $rowCurBall['sisaPaket'];

																	if($pulsa != NULL && $pulsa != '' && $pulsa != "0"){
																		$pulsaAkhir[] = ($pulsa < 20000)?"<span class='red-text'>".number_format($pulsa, 0, ',', '.')."</span>":number_format($pulsa, 0, ',', '.')		;
																	}else{
																		$pulsaAkhir[] = "-";
																	}
																}
																echo join(' / ', $pulsaAkhir);
															}else{
																echo "-";
															}
														}
													?>
												</td>
								            <?php
								            unset($pulsaAkhir);
										}
									?>
								</tr>
							<?php
						}
					?>
				</tbody>
			</table>
		</div>
	</div>
	<div class="col s12">
		<a href="./index.php" class="btn waves-effect waves-light blue-cermati" name="action">Back
			<i class="material-icons right">subdirectory_arrow_left</i>
		</a>
	</div>
</div>