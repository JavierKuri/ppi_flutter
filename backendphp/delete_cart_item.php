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
        $id_carrito = $_POST['id_carrito'];
        $sql = "DELETE FROM carrito WHERE id_carrito = $id_carrito;";
        $result = mysqli_query($con, $sql);

        if (!$result) {
            http_response_code(500);
            echo json_encode(["error" => "Query failed: " . mysqli_error($con)]);
            exit;
        } else {
            http_response_code(200); 
            echo json_encode(["success" => true]); 
        }
        
     } else {
        http_response_code(405);
        echo json_encode(['error' => 'Only POST method is accepted']);
     }
    mysqli_close($con);
?>
