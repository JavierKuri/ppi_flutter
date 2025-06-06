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
        $cart = [];

        $sql = "SELECT titulo, precio, id_carrito FROM carrito, juegos, usuarios WHERE carrito.id_usuario = usuarios.id_usuario 
                                                        AND carrito.id_juego = juegos.id_juego
                                                        AND usuarios.id_usuario = $id_usuario
                                                        ORDER BY id_carrito DESC;";
        $result = mysqli_query($con, $sql);

        if (!$result) {
            http_response_code(500);
            echo json_encode(["error" => "Query failed: " . mysqli_error($con)]);
            exit;
        }

        while ($row = mysqli_fetch_assoc($result)) {
            $cart[] = $row;
        }

        if (empty($cart)) {
            echo json_encode([]);
            mysqli_close($con);
            exit;
        }

        echo json_encode($cart);
     } else {
        http_response_code(405);
        echo json_encode(['error' => 'Only POST method is accepted']);
     }
    mysqli_close($con);
?>
