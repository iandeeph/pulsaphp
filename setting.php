<div class="container">
	<div class="col s12 border-bottom">
		<h4>SIM Card Configuration</h4>
	</div>
	<div class="col s12 mt-30">
		<ul class="collapsible popout" data-collapsible="accordion">
			<?php
				$hostQry = "";
				$hostQry = "SELECT host FROM provider WHERE host != '0.0.0.0' GROUP BY host ORDER BY host";
				if($resultHost = mysql_query($hostQry)){
				    if (mysql_num_rows($resultHost) > 0) {
				        while($rowHost 	= mysql_fetch_array($resultHost)){
				        	$host = $rowHost['host'];
							?>
								<li>
									<div class="collapsible-header">Host : <?php echo $host; ?></div>
									<div class="collapsible-body">
										<div class="almost-full">
											<ul class="collapsible-span mb-30" data-collapsible="accordion">
												<?php
												$spanQry = "";
												$spanQry = "SELECT idProvider, span FROM provider WHERE host = '".$host."' AND span != '0' ORDER BY span";
												if($resultSpan = mysql_query($spanQry)){
												    if (mysql_num_rows($resultSpan) > 0) {
												        while($rowSpan 	= mysql_fetch_array($resultSpan)){
												        	$span 		= $rowSpan['span'];
												        	$idProvider = $rowSpan['idProvider'];

												        	$trunks = new trunks($host, $span, $today, $name);

												        	
												        	?>
															<li>
													        	<div class="collapsible-header">Span <?php echo $span; ?></div>
																<div class="collapsible-body almost-full">
																	<div class="row ml-20">
																		<form action="#" method="post" class="col s12">
																			<div class="row">
																				<div class="input-field col s12">
																					<input value="<?php echo $trunks->name;?>" id="<?php echo "namaProvider-".$idProvider;?>" name="<?php echo "namaProvider-".$idProvider;?>" type="text" class="validate">
																					<label for="<?php echo "namaProvider-".$idProvider;?>">Nama Provider</label>
																				</div>
																				<div class="input-field col s12 m6 l6">
																					<input value="<?php echo $trunks->no;?>" id="<?php echo "noProvider-".$idProvider;?>" name="<?php echo "noProvider-".$idProvider;?>" type="text" class="validate">
																					<label for="<?php echo "noProvider-".$idProvider;?>">Nomor Provider</label>
																				</div>
																				<div class="input-field col s12 m6 l6">
																					<input value="<?php echo $trunks->namaPaket;?>" id="<?php echo "namaPaket-".$idProvider;?>" name="<?php echo "namaPaket-".$idProvider;?>" type="text" class="validate">
																					<label for="<?php echo "namaPaket-".$idProvider;?>">Nama Paket</label>
																				</div>
																				<div class="input-field col s12 m6 l6">
																					<input value="<?php echo $trunks->hargaPaket;?>" id="<?php echo "hargaPaket-".$idProvider;?>" name="<?php echo "hargaPaket-".$idProvider;?>" type="number" class="validate">
																					<label for="<?php echo "hargaPaket-".$idProvider;?>">Harga Paket</label>
																				</div>
																				<div class="input-field col s12 m6 l6">
																					<input value="<?php echo $trunks->caraAktivasi;?>" id="<?php echo "caraAktivasi-".$idProvider;?>" name="<?php echo "caraAktivasi-".$idProvider;?>" type="text" class="validate">
																					<label for="<?php echo "caraAktivasi-".$idProvider;?>">Cara Aktivasi</label>
																				</div>
																				<div class="input-field col s12 m6 l6">
																					<input value="<?php echo $trunks->caraCekKuota;?>" id="<?php echo "caraCekKuota-".$idProvider;?>" name="<?php echo "caraCekKuota-".$idProvider;?>" type="text" class="validate">
																					<label for="<?php echo "caraCekKuota-".$idProvider;?>">Cara Cek Kuota</label>
																				</div>
																				<div class="input-field col s12 m6 l6">
																					<input value="<?php echo $trunks->expPaket;?>" id="<?php echo "expDatePaket-".$idProvider;?>" name="<?php echo "expDatePaket-".$idProvider;?>" type="text" class="validate">
																					<label for="<?php echo "expDatePaket-".$idProvider;?>">Expired Date Paket</label>
																				</div>
																				<div class="col s12">
																					<a href="<?php echo "#confirmSubmit-".$idProvider;?>" class="modal-trigger btn waves-effect waves-light blue-cermati right" name="action">Submit
																						<i class="material-icons right">send</i>
																					</a>
																				</div>
																				<div id="<?php echo "confirmSubmit-".$idProvider;?>" class="modal">
																					<div class="modal-content">
																						<h4>Konfirmasi Submit</h4>
																						<h5>Apakah anda yakin ?</h5>
																					</div>
																					<div class="modal-footer col s12 mb-10">
																						<input value="<?php echo $trunks->id;?>" type="hidden" name="<?php echo "idTrunks-".$idProvider;?>">
																						<button type="submit" name="<?php echo "buttonEditTrunks-".$idProvider;?>" class="mr-10 waves-effect waves-light btn blue-cermati right">Yes</button>
																						<a href="#!" class="ml-10 mr-10 modal-action modal-close waves-effect waves-light btn grey right">Cancel</a>
																					</div>
																				</div>
																				<?php
																		        	if (isset($_POST['buttonEditTrunks-'.$idProvider])) {
																	        		    $postId             = $_POST['idTrunks-'.$idProvider];
																						$postNamaProvider   = $_POST['namaProvider-'.$idProvider];
																						$postNomorProvider  = $_POST['noProvider-'.$idProvider];
																						$postNamaPaket      = $_POST['namaPaket-'.$idProvider];
																						$postHargaPaket     = $_POST['hargaPaket-'.$idProvider];
																						$postCaraAktivasi   = $_POST['caraAktivasi-'.$idProvider];
																						$postCaraCekKuota   = $_POST['caraCekKuota-'.$idProvider];
																						$postExpDatePaket   = $_POST['expDatePaket-'.$idProvider];

																		        		$trunks->submit($postId, $postNamaProvider, $postNomorProvider, $postNamaPaket, $postHargaPaket, $postCaraAktivasi, $postCaraCekKuota, $postExpDatePaket);
																		        	}
																		        ?>
																			</div>
																		</form>
																	</div>
																</div>
															</li>
															<?php
														}
													}
												}
												?>
											</ul>
										</div>
									</div>
								</li>
							<?php
						}
					}
				}
			?>
		</ul>
	</div>
</div>