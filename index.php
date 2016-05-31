<?php
ob_start();
ini_set("display_errors", "1");
error_reporting(E_ALL ^ E_DEPRECATED);
date_default_timezone_set('Asia/Jakarta');
session_start();

require "sql/connect.php";
require "php/pulsa.php";
include 'trunks.php';
?>
<!DOCTYPE html>
<html>
	<head>
		<!--Import Google Icon Font-->
		<link href="css/material-icon.css" rel="stylesheet">
		<link href='https://fonts.googleapis.com/css?family=Kaushan+Script|Quattrocento+Sans' rel='stylesheet' type='text/css'>

		<!--Import materialize.css-->
		<link type="text/css" rel="stylesheet" href="css/materialize.css"  media="screen,projection"/>
		<link rel="stylesheet" href="css/style.css">
		<!-- favicon -->
		<link rel="apple-touch-icon" sizes="57x57" href="icon/apple-icon-57x57.png">
		<link rel="apple-touch-icon" sizes="60x60" href="icon/apple-icon-60x60.png">
		<link rel="apple-touch-icon" sizes="72x72" href="icon/apple-icon-72x72.png">
		<link rel="apple-touch-icon" sizes="76x76" href="icon/apple-icon-76x76.png">
		<link rel="apple-touch-icon" sizes="114x114" href="icon/apple-icon-114x114.png">
		<link rel="apple-touch-icon" sizes="120x120" href="icon/apple-icon-120x120.png">
		<link rel="apple-touch-icon" sizes="144x144" href="icon/apple-icon-144x144.png">
		<link rel="apple-touch-icon" sizes="152x152" href="icon/apple-icon-152x152.png">
		<link rel="apple-touch-icon" sizes="180x180" href="icon/apple-icon-180x180.png">
		<link rel="icon" type="image/png" sizes="192x192"  href="icon/android-icon-192x192.png">
		<link rel="icon" type="image/png" sizes="32x32" href="icon/favicon-32x32.png">
		<link rel="icon" type="image/png" sizes="96x96" href="icon/favicon-96x96.png">
		<link rel="icon" type="image/png" sizes="16x16" href="icon/favicon-16x16.png">
		<link rel="manifest" href="icon/manifest.json">
		<meta name="msapplication-TileColor" content="#ffffff">
		<meta name="msapplication-TileImage" content="icon/ms-icon-144x144.png">
		<meta name="theme-color" content="#ffffff">
		<!-- tyni mce -->
		<script src='js/tinymce/tinymce.min.js'></script>
		<!--Let browser know website is optimized for mobile-->
		<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
		<title>Cermati Pulsa</title>
	</head>
  <body>
		<header>
			<div class="navbar-fixed white darken-3">
				<nav class="white darken-3">
					<div class="nav-wrapper navbar-fixed white darken-3">
						<?php
							if(isset($_SESSION['login']) && $_SESSION['login'] == 'logged'){
								?>
									<a href="#" data-activates="side-menu" class="button-collapse left ml-30 grey-text text-darken-2"><i class="menu-side-icon material-icons">menu</i></a>
								<?php
							}
						?>
						<a href="./" class="center brand-logo"><img class="admin-logo mt-10" src="images/logo.png"></a>
						<div style="width:100%" class="hide-on-med-and-down"><span class="right mr-30 font-25 blue-cermati-text">Cermati Pulsa</span></div>
						<ul class="right hide-on-med-and-down mr-30">
							<?php
							if(isset($_SESSION['login']) && $_SESSION['login'] == 'logged'){
							?>
								<li><a class="grey-text text-darken-2" href="./index.php?menu=setting">SIM card settings</a></li>
								<li><a class="grey-text text-darken-2" href="./index.php?menu=logout">Logout [<?php echo $name;?>]</a></li>
							<?php
							}else{
							?>
								<li><a class="modal-trigger grey-text text-darken-2" href="#modalLogin">Login</a></li>
							<?php
							}
						?>
						</ul>
						<ul class="side-nav" id="side-menu">
							<li><a class="center blue-cermati-text disabled" disabled>Cermati Pulsa</a></li>
							<li class="divider"></li>
							<?php
							if(isset($_SESSION['login']) && $_SESSION['login'] == 'logged'){
							?>
								<li><a href="./index.php?menu=setting"><i class="menu-side-icon material-icons left">sim_card</i>Settings</a></li>
								<li class="divider"></li>
								<li><a href="./index.php?menu=logout"><i class="menu-side-icon material-icons left">power_settings_new</i>Logout [<?php echo $name;?>]</a></li>
							<?php
							}else{
							?>
								<li class="divider"></li>
								<li class="bold"><a href="#modalLogin" class="modal-trigger"><i class="menu-side-icon material-icons mt-20 left">power_settings_new</i>Login</a></li>
							<?php
							}
						?>
						</ul>
					</div>
				</nav>
			</div>
		</header>
    <main>
    	<div>
		    <?php
		    if(isset($_SESSION['login']) && $_SESSION['login'] == 'logged'){
				switch ($menu) {
					case 'home':
						include 'home.php';
						break;
					case 'pulsa':
						include 'perdates-pulsa.php';
						break;
					case 'paket':
						include 'perdates-paket.php';
						break;
					case 'setting':
						include 'setting.php';
						break;
					case 'log':
						include 'log.php';
						break;
					case 'logout':
						include 'logout.php';
						break;
					default:
						include 'home.php';
						break;
		        }
		    }else{
		    	switch ($menu) {
					case 'home':
						include 'home.php';
						break;
					case 'pulsa':
						include 'perdates-pulsa.php';
						break;
					case 'paket':
						include 'perdates-paket.php';
						break;
					case 'logout':
						include 'logout.php';
						break;
					default:
						include 'home.php';
						break;
		        }
		    }
		    ?>
    	</div>
    	<!-- ============== modal login -->
		<div id="modalLogin" class="modal">
			<div class="modal-content">
				<div class="row">
					<div class="col s12">
						<form action="#" method="post" enctype="multipart/form-data">
							<div class="col s12 blue-text text-darken-4 center hide-on-med-and-up mt-20">
								<h5>CERMATI INVENTORY</h5>
							</div>
							<div class="col s12 center">
								<h4>LOGIN</h4>
							</div>
							<div class="input-field col s12">
								<input id="loginUsername" name="loginUsername" type="text" class="validate" required>
								<label for="loginUsername">Username</label>
							</div>
							<div class="input-field col s12">
								<input id="loginPassword" name="loginPassword" type="password" class="validate" required>
								<label for="loginPassword">Password</label>
							</div>
							<div class="input-field col s12">
								<button type="submit" name="btnLogin" class="waves-effect waves-light btn black right"><i class="material-icons left">send</i>Login</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
    </main>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>
    <script type="text/javascript" src="js/jquery-2.1.1.min.js"></script>
    <script type="text/javascript" src="js/materialize.min.js"></script>
    <script type="text/javascript" src="js/pulsa.js"></script>
  </body>
</html>