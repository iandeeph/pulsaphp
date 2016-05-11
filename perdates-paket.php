<div class="col s12 ml-10 mr-10">
	<div class="col s12">
		<h4>Sisa Paket Cermati</h4>
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
	<div id="home-table" class="mt-30">
		<div class="col s12">
			<table class="bordered auto-scroll">
				<thead>
					<tr class="border-bottom">
						<th class="border-right" rowspan="3">
							Provider
						</th>
						<th class="border-right" colspan="<?php echo ($daycount*(count($jamCekPaket)-1)); ?>">
							Paket / Tanggal & Jam
						</th>
					</tr>
					<tr class="border-bottom">
						<?php
							for ($i=1; $i <= $daycount ; $i++) {
								?>
									<th class="border-right" colspan="<?php echo (count($jamCekPaket)-1); ?>">
										<?php echo $i;?>
									</th>
								<?php
							}
						?>
					</tr>
					<tr class="border-bottom">
						<?php
							for ($i=1; $i <= $daycount ; $i++) {
								for ($j=0; $j < (count($jamCekPaket)-1); $j++) {
									echo '<th class="border-right">';
									echo $jamCekPaket[$j];
									echo '</th>';
								}
							}
						?>
					</tr>
				</thead>
				<tbody>
					<?php
						for ($k=1; $k <= count($idProvider); $k++) {
							?>
								<tr>
									<td>
										<?php echo $namaProvider[$k]; ?>
									</td>
										<?php
											for ($j=1; $j <= $daycount ; $j++) {
												for ($check=0; $check < (count($jamCekPaket)-1); $check++) {
													$startDate 	= $postDate."-".sprintf("%02d", $j)." ".$jamCekPaket[$check].":01";
													$endDate 	= $postDate."-".sprintf("%02d", $j)." ".$jamCekPaket[($check+1)].":00";

													$currBalQry = "";
													$currBalQry = "SELECT namaProvider, sisaPaket FROM paket WHERE namaProvider = '".$namaProvider[$k]."' AND tanggal between '".$startDate."' AND '".$endDate."' LIMIT 1";
													if($resultCurBal = mysql_query($currBalQry)){
														if (mysql_num_rows($resultCurBal) > 0) {
															while($rowCurBall = mysql_fetch_array($resultCurBal)){
																$provName		= $rowCurBall['namaProvider'];
																$paket			= $rowCurBall['sisaPaket'];

																echo '<td class="fixed">';
																echo parsePulsa($paket, 30);
																echo '</td>';
															}
														}else{
															echo '<td class="fixed">-</td>';
														}
													}
												}
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