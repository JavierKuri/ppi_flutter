<?php
ini_set('display_errors', 1);
error_reporting(E_ALL);

$con = mysqli_connect('localhost', 'root', '', 'finalppi');

if (!$con) {
    die('Connect error: ' . mysqli_connect_error());
}

$result = mysqli_query($con, "SELECT * FROM juegos");

if (!$result) {
    die('Query error: ' . mysqli_error($con));
}

while ($row = mysqli_fetch_assoc($result)) {
    print_r($row);
}

mysqli_close($con);
?>
