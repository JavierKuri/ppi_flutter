<?php
    ini_set('display_errors', 1);
    error_reporting(E_ALL);
    header('Content-Type: application/json');
    include 'config.php';

     if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            if (!$con) {
            echo json_encode(['error' => 'No connection']);
            exit;
        }
        $id_usuario = $_POST['id_usuario'] ?? '';
        $id_juego = $_POST['id_juego'] ?? '';
        $sql = "INSERT INTO carrito (id_usuario, id_juego) VALUES ('$id_usuario', '$id_juego')";
        $result = mysqli_query($con, $sql);

        if (!$result) {
            http_response_code(500);
            echo json_encode(["error" => "Query failed: " . mysqli_error($con)]);
            exit;
        }
        
     } else {
        http_response_code(405);
        echo json_encode(['error' => 'Only POST method is accepted']);
     }
    mysqli_close($con);
?>
