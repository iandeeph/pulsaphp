<?php
$servername = "1.1.1.200";
$username = "root";
$password = "c3rmat";
$dbname = "db_agen_pulsa";

// Create connection
$conn = mysql_connect($servername, $username, $password, $dbname);
$select = mysql_select_db($dbname, $conn);
// Check connection
if (!$select) {
    die("Connection failed: " . mysql_error());
}
?>