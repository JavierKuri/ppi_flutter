<?php
    $host = "localhost";
    $db = "finalppi";
    $user = "root";
    $pass = "";

    $con = mysqli_connect($host, $user, $pass, $db);
    if (!$con) {
        http_response_code(500);
        echo json_encode(["error" => "Database connection failed"]);
        exit();
    }
?>
