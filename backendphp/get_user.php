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
    $sql = "SELECT * FROM usuarios WHERE id_usuario = $id_usuario;";
    
    $result = mysqli_query($con, $sql);
    if (!$result) {
        http_response_code(500);
        echo json_encode(["error" => "Query failed: " . mysqli_error($con)]);
        exit;
    }

    $row = mysqli_fetch_assoc($result);
    if ($row) {
        echo json_encode($row);
    } else {
        echo json_encode(['message' => 'No rows found']);
    }
} else {
    http_response_code(405);
    echo json_encode(['error' => 'Only POST method is accepted']);
}

mysqli_close($con);
?>
