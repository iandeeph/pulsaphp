<div class="col s12 ml-10 mr-10">
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
	<div id="home-table" class="mt-30">
		<div class="col s12">
			<table class="bordered auto-scroll">
				<thead>
					<tr class="border-bottom">
						<th class="border-right" rowspan="3">
							Provider
						</th>
						<th class="border-right" colspan="<?php echo ($daycount*3); ?>">
							Pulsa / Tanggal & Jam
						</th>
					</tr>
					<tr class="border-bottom">
						<?php
							for ($i=1; $i <= $daycount ; $i++) {
								?>
									<th class="border-right" colspan="3">
										<?php echo $i;?>
									</th>
								<?php
							}
						?>
					</tr>
					<tr class="border-bottom">
						<?php
							for ($i=1; $i <= $daycount ; $i++) {
								?>
									<th class="border-right">
										08:15
									</th>
									<th class="border-right">
										12:15
									</th>
									<th class="border-right">
										17.15
									</th>
								<?php
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
												$startDate[1] 	= $postDate."-".sprintf("%02d", $j)." 05:01:00";
												$endDate[1] 	= $postDate."-".sprintf("%02d", $j)." 12:00:00";
												$startDate[2] 	= $postDate."-".sprintf("%02d", $j)." 12:01:00";
												$endDate[2] 	= $postDate."-".sprintf("%02d", $j)." 17:00:00";
												$startDate[3]	= $postDate."-".sprintf("%02d", $j)." 17:01:00";
												$endDate[3] 	= $postDate."-".sprintf("%02d", $j)." 23:59:00";

												for ($i=1; $i <= 3; $i++) {
													$currBalQry = "";
													// $currBalQry = "SELECT namaProvider, sisaPulsa FROM pulsa WHERE namaProvider = '".$namaProvider[$k]."' AND date_format(tanggal, '%Y-%m-%d')='".$qryTanggal."' LIMIT 1";
													$currBalQry = "SELECT namaProvider, sisaPulsa FROM pulsa WHERE namaProvider = '".$namaProvider[$k]."' AND tanggal between '".$startDate[$i]."' AND '".$endDate[$i]."' LIMIT 1";
													if($resultCurBal = mysql_query($currBalQry)){
														if (mysql_num_rows($resultCurBal) > 0) {
															while($rowCurBall = mysql_fetch_array($resultCurBal)){
																$provName		= $rowCurBall['namaProvider'];
																$pulsa			= $rowCurBall['sisaPulsa'];

																echo '<td class="fixed">';
																echo parsePulsa($pulsa, $hargaPaket[$provName]);
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
		<a href="./index.php?menu=paket" class="btn waves-effect waves-light blue-cermati" name="action">Table Paket
			<i class="material-icons right">send</i>
		</a>
	</div>
</div>