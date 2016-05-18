<?php
	$postMessages = isset($postMessages)?$postMessages:'';
	$colorMessages = isset($colorMessages)?$colorMessages:'';
	// ============================== BUTTON DELETE CLICK ==========================================================
	if(isset($_POST['btnDeleteLog'])){
		$delLogQry = "DELETE FROM log WHERE idlog in (".implode($_POST['checkboxLog'], ',').")";
		if (mysql_query($delLogQry)) {
			$postMessages =  "Record deleted successfully";
			$colorMessages = "green-text";
		} else {
		    $postMessages = "Error deleting record: " . mysql_error($conn);
        	$colorMessages = "red-text";
		}
	}

	// ===================================================== pagination
	if(!isset($_GET['pages'])){
		$_GET['pages'] = 1;
	}
	
	$logPerPages = "";
	$logPerPages = "SELECT count(action) as countAction FROM log";
	if ($resultLog = mysql_query($logPerPages)){
		if (mysql_num_rows($resultLog) > 0) {
			$rowItemPerPage = mysql_fetch_array($resultLog);
			$totalLog = $rowItemPerPage['countAction'];
			// if total query more than 15, item perpage will be 15 items
			if($totalLog >= 15){
				$perPages = 15;
				// if total pages show more than 10 pages, pages will still show 10 pages.. value will increase when pages higher
				$totalPages = ceil($totalLog/$perPages);
			// on this time, total log must be less than 15, so this filter if total log more than or equal 0 and less than 15
			}elseif($totalLog >= 0 && $totalLog < 15){
				$perPages = $totalLog;
				$totalPages = 1;
			}else{
				$perPages = $totalLog;
				$totalPages = 1;
			}
			
			//pagination code
			if(isset($_GET['pages'])){
				$curPages = $_GET['pages'];
				$page=intval($_GET['pages']);
				if ($curPages>0 && $curPages<=$totalPages) {
					$start = ($curPages-1)*$perPages;
					$end = $start+$perPages;
				}else{
					$start=0;
					$end=$perPages;
				}
			}else{
				$start=0;
				$end=$perPages;
			}

			$page = ($page <= 0)?1:$page;;
			$dissleft = ($curPages <= 1)?"disabled":"";
			$dissright = ($curPages >= $totalPages)?"disabled":"";
			$almostLast = $totalPages-4;

			if ($curPages > 1) {
				$prevCurPages = $curPages-1;
				$prevPage = $_SERVER['PHP_SELF']."?menu=log&pages=".$prevCurPages;
			}else{
				$prevPage = '';
			}
			if ($curPages < $totalPages) {
				$nextCurPages = $curPages+1;
				$nextPage = $_SERVER['PHP_SELF']."?menu=log&pages=".$nextCurPages;
			}else{
				$nextPage = '';
			}

			if($curPages <= 0 || $curPages > $totalPages){
				header('Location: ./?menu=log&pages=1');
			}elseif ($curPages >= 1 && $curPages <= 5) {
				$firstPosPage = 1;
				$lastPosPage = ($totalPages < 10)? $totalPages: 10;
			}elseif ($curPages > 5 && $curPages < $almostLast) {
				$firstPosPage = $curPages-4;
				$lastPosPage = $curPages+4;
			}elseif ($curPages >= $almostLast && $curPages <= $totalPages) {
				$firstPosPage = ($totalPages >= 10)?$totalPages-9:1;
				$lastPosPage = $totalPages;
			}else{
				header('Location: ./?menu=log&pages=1');
			}
		}
	} else {
	    alertBox(mysql_error($conn));
	}
?>
<div class="row">
	<div class="col s12 border-bottom grey lighten-2 mb-50">
		<h3 class="left-align">Activity Log</h3>
	</div>
	<div class="col s12">
		<form action="#" method="post" enctype="multipart/form-data">
			<div class="col s12 mb-30">
				<a id="delSelectionLogButton" href="#modalDelLogItems" class="waves-effect waves-light btn red accent-4 disabled" disabled><i class="material-icons left">delete</i>Delete</a>
			</div>
			<div class="col s12">
				<span class="<?php echo $colorMessages;?>"><?php echo $postMessages;?></span>
			</div>
			<table class="striped responsive-table">
				<thead>
					<tr class="hide-on-small-only">
						<th width="5%">
							<p>
								<input type="checkbox" id="checkAll" />
								<label for="checkAll"></label>
							</p>
						</th>
						<th width="15%">
							Date
						</th>
						<th width="10%">
							User
						</th>
						<th width="20%">
							Action
						</th>
						<th width="100%">
							Action Detail
						</th>
					</tr>
					<tr class="hide-on-med-and-up">
						<th>
							<p>
								<input type="checkbox" id="checkAll" />
								<label for="checkAll"></label>
							</p>
						</th>
						<th>
							Date
						</th>
						<th>
							User
						</th>
						<th>
							Action
						</th>
						<th>
							Action Detail
						</th>
					</tr>
				</thead>
				<tbody>
					<?php
						if($resultLogQry = mysql_query("SELECT *, DATE_FORMAT(date,'%e %b %Y - %H:%i:%s') as dateFormated FROM log ORDER BY date DESC LIMIT ".$perPages." OFFSET ".$start."")){
							if (mysql_num_rows($resultLogQry) > 0) {
								while ($rowLog = mysql_fetch_array($resultLogQry)) {
									$idlog      = $rowLog['idlog'];
									$dateLog    = $rowLog['dateFormated'];
									$userLog  	= $rowLog['user'];
									$actionLog  = $rowLog['action'];
									$valueLog 	= $rowLog['value'];
									$iditemLog 	= $rowLog['iditem'];
									?>
										<tr>
											<td>
												<p>
													<input name="checkboxLog[]" type="checkbox" id="<?php echo $idlog; ?>" value="<?php echo $idlog; ?>" />
													<label for="<?php echo $idlog; ?>"></label>
													<input name="<?php echo $iditemLog; ?>" type="hidden" id="<?php echo $iditemLog; ?>" value="<?php echo $iditemLog; ?>" />
												</p>
											</td>
											<td>
												<?php echo $dateLog; ?>
											</td>
											<td>
												<?php echo $userLog; ?>
											</td>
											<td>
												<?php echo $actionLog; ?>
											</td>
											<td>
												<?php echo nl2br($valueLog); ?>
											</td>
										</tr>
									<?php
								}
							}
						}
					?>
				</tbody>
			</table>
			<div id="modalDelLogItems" class="modal">
				<div class="modal-content">
					<h4>Deleting Confirmation</h4>
					<h5>Are you sure want to delete selected item(s) ?</h5>
				</div>
				<div class="modal-footer col s12 mb-50">
					<button type="submit" name="btnDeleteLog" class="waves-effect waves-light btn green darken-4 right">Yes</button>
					<a href="#!" class="modal-action modal-close waves-effect waves-light btn blue darken-4 right">Cancel</a>
				</div>
			</div>
		</form>
		<div class="divider mt-30"></div>
		<div class="row">
			<div class="col s12">
				<div class="center">
					<ul class="pagination">
						<?php
						?>
						<li class="waves-effect <?php echo $dissleft; ?>" <?php echo $dissleft; ?>><a href="<?php echo $prevPage; ?>" class="<?php echo $dissleft; ?>"><i class="material-icons">chevron_left</i></a></li>
							
						<?php

							for ($j=$firstPosPage; $j <= $lastPosPage; $j++) {
								$active = ($curPages == $j)?"active":"";
								echo "<li class='".$active."'><a href='".$_SERVER['PHP_SELF']."?menu=log&pages=".$j."'>".$j."</a></li>";
							}

							?>

						<li class="waves-effect <?php echo $dissright; ?>"><a href="<?php echo $nextPage; ?>" class="<?php echo $dissright; ?>"><i class="material-icons">chevron_right</i></a></li>
					</ul>
				</div>
			</div>
		</div>
	</div>
</div>