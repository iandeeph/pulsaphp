<?php
	$_SESSION['login']  = 'notlogged';
	session_destroy();
	header('Location: ./');
?>