<?php
    ini_set('display_errors', 1);
    error_reporting(E_ALL);
    header('Content-Type: application/json');
    include 'config.php';

    if (!$con) {
        echo json_encode(['error' => 'No connection']);
        exit;
    }

    $juegos = [];
    $busqueda = isset($_GET['busqueda']) ? mysqli_real_escape_string($con, $_GET['busqueda']) : '';
    if ($busqueda !='') {
        $sql = "SELECT * FROM juegos WHERE titulo LIKE '%$busqueda%' ORDER BY titulo;";
    } else {
        $sql = "SELECT * FROM juegos ORDER BY titulo;";
    }
    $result = mysqli_query($con, $sql);

    if (!$result) {
        http_response_code(500);
        echo json_encode(["error" => "Query failed: " . mysqli_error($con)]);
        exit;
    }

    while ($row = mysqli_fetch_assoc($result)) {
        if (isset($row['portada'])) {
            $row['portada'] = base64_encode($row['portada']);
        }
        $juegos[] = $row;
    }

    if (empty($juegos)) {
        echo json_encode([]);
        mysqli_close($con);
        exit;
    }

    echo json_encode($juegos);
    mysqli_close($con);
?>
