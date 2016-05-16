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
	<div class="mt-30 home-table">
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
									<th id="<?php echo 'tanggal'.$i;?>" class="border-right" colspan="<?php echo count(getJamPaket($postDate."-".sprintf("%02d", $i))); ?>">
										<?php echo $i;?>
									</th>
								<?php
							}
						?>
					</tr>
					<tr class="border-bottom">
						<?php
							for ($i=1; $i <= $daycount ; $i++) {
								for ($j=0; $j < count(getJamPaket($postDate."-".sprintf("%02d", $i))); $j++) {
									echo '<th class="border-right">';
									echo getJamPaket($postDate."-".sprintf("%02d", $i), $j);
									echo '</th>';
								}
							}
						?>
					</tr>
				</thead>
				<tbody>
					<?php
						// Create empty value array
						$listProvider = array();
						foreach($namaProvider as $provider) {
							$listProvider[$provider] = array();
							for ($i=1; $i <= $daycount ; $i++) {
								$listProvider[$provider][$i] = array();
								for ($j=0; $j < count(getJamPaket($postDate."-".sprintf("%02d", $i))); $j++) {
									$listProvider[$provider][$i][getJamPaket($postDate."-".sprintf("%02d", $i), $j)] = "-";
								}
							}
						}
						$currBalQry = "";
						$currBalQry = "SELECT DISTINCT(tanggal),
						namaProvider, sisaPulsa, DAYOFMONTH(tanggal) as tgl,
						DATE_FORMAT(tanggal, '%H:%i') as waktu,
						HOUR(tanggal) as jam,
						MINUTE(tanggal) as menit 
						FROM pulsa 
						WHERE namaProvider in("."'".implode("','", $namaProvider)."'".") 
							AND YEAR(tanggal) = '".$postYear."' 
							AND MONTH(tanggal) = '".$postMonth."' 
							ORDER BY namaProvider, 
							tgl, 
							jam + 0, 
							menit + 0";
						$resultCurBal = mysql_query($currBalQry) or die(mysql_error());
						if($resultCurBal){
							$resultCount = mysql_num_rows($resultCurBal);
							if ($resultCount > 0) {
								while($rowCurBall = mysql_fetch_array($resultCurBal)){
									if (isset($listProvider[$rowCurBall["namaProvider"]][$rowCurBall["tgl"]][$rowCurBall["waktu"]])) {
										$listProvider[$rowCurBall["namaProvider"]][$rowCurBall["tgl"]][$rowCurBall["waktu"]] = $rowCurBall["sisaPulsa"];
									}
								}
							}
						}

						foreach ($listProvider as $provider => $days) {
							echo "<tr>";
							echo "<td>".$provider."</td>";
							foreach ($days as $day => $times) {
								foreach ($times as $time => $pulsa) {
									echo "<td class='fixed'>".parsePulsa(intval($pulsa), $hargaPaket[$provider])."</td>";
								}
							}
							echo "</tr>";
						}
					?>
				</tbody>
			</table>
		</div>
	</div>
	<div class="col s12">
		<a href="./index.php" class="btn waves-effect waves-light blue-cermati" name="action">Home
			<i class="material-icons right">home</i>
		</a>
		<a href="./index.php?menu=paket" class="btn waves-effect waves-light blue-cermati" name="action">Table Paket
			<i class="material-icons right">send</i>
		</a>
	</div>
</div>