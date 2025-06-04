<?php
    ini_set('display_errors', 1);
    error_reporting(E_ALL);
    header('Content-Type: application/json');
    include 'config.php';

    if (!$con) {
        echo json_encode(['error' => 'No connection']);
        exit;
    }

    $historial = [];

    $sql = "SELECT titulo, precio, id_compra FROM compras, juegos WHERE compras.id_juego = juegos.id_juego ORDER BY id_compra DESC;";
    $result = mysqli_query($con, $sql);

    if (!$result) {
        http_response_code(500);
        echo json_encode(["error" => "Query failed: " . mysqli_error($con)]);
        exit;
    }

    while ($row = mysqli_fetch_assoc($result)) {
        $historial[] = $row;
    }

    if (empty($historial)) {
        echo json_encode(['message' => 'No rows found']);
        mysqli_close($con);
        exit;
    }

    echo json_encode($historial);
    mysqli_close($con);
?>
