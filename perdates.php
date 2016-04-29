<div class="container">
	<div class="col s12">
		<h4>Sisa Pulsa Cermati</h4>
	</div>
	<div class="col s12">
	<form id="simulation-form" role="form" class="margin-top-30" data-ajax-error="Mohon maaf, ada masalah saat memproses permintaan Anda. Mohon dicoba kembali setelah beberapa saat." action="#focus-simulation" novalidate="true">
		<div class="margin-bottom-20">

			<!--Tenure -->
			<div class="col-xs-12 col-md-6">
				<div class="col-xs-12">
					<label>Pilih Bulan</label>
					<div class="col-xs-12 nopadding grouped-input fixed  margin-top-20">
						<select class="form-control" name="tenure" id="tenure-slider">
							<option value="12">12</option>
							<option value="18">18</option>
							<option value="24" selected="selected">24</option>
							<option value="30">30</option>
							<option value="36">36</option>
							<option value="42">42</option>
							<option value="48">48</option>
							<option value="54">54</option>
							<option value="60">60</option>
						</select>
					</div>
				</div>
			</div>
			<!-- End Tenure-->
		</div>
	</form>
    </div>
	<div id="simulation-table" class="mt-30">
		<div class="col s2">
			<table class="bordered">
				<thead>
					<tr class="border-bottom">
						<th data-filed="tanggal" class="border-right" rowspan="2">
							Tanggal
						</th>
						<!-- <th data-filed="provider" class="border-right hide-on-med-and-down" colspan="<?php echo count($idProvider);?>">
							Nama Trunk (Provider)
						</th> -->
					</tr>
					<tr>
						<?php
							for ($i=0; $i < count($idProvider) ; $i++) {
								echo '<th data-filed="trunks">'.$namaProvider[$i].'</th>';
							}
						?>
					</tr>
				</thead>
				<tbody>
					<?php
						for ($i=1; $i <= $daycount ; $i++) {
					        ?>
								<tr>
									<td>
										<?php echo $i;?>
									</td>
									<?php
										for ($j=0 ;$j < count($idProvider); $j++) {
											?>
											<td>
												000000
									        </td>
								            <?php
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