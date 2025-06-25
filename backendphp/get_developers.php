<?php
    ini_set('display_errors', 1);
    error_reporting(E_ALL);
    header('Content-Type: application/json');
    include 'config.php';

    if (!$con) {
        echo json_encode(['error' => 'No connection']);
        exit;
    }

    $desarrolladores = [];
    $sql = $sql = "SELECT DISTINCT desarrollador FROM juegos ORDER BY desarrollador;";
    $result = mysqli_query($con, $sql);

    if (!$result) {
        http_response_code(500);
        echo json_encode(["error" => "Query failed: " . mysqli_error($con)]);
        exit;
    }

    while ($row = mysqli_fetch_assoc($result)) {
        $desarrolladores[] = $row;
    }

    if (empty($desarrolladores)) {
        echo json_encode([]);
        mysqli_close($con);
        exit;
    }

    echo json_encode($desarrolladores);
    mysqli_close($con);
?>
