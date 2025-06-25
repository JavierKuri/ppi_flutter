<?php
    ini_set('display_errors', 1);
    error_reporting(E_ALL);
    header('Content-Type: application/json');
    include 'config.php';

    if (!$con) {
        echo json_encode(['error' => 'No connection']);
        exit;
    }

    $busqueda = isset($_GET['busqueda']) ? mysqli_real_escape_string($con, $_GET['busqueda']) : '';
    $ordenar = isset($_GET['ordenar']) ? mysqli_real_escape_string($con, $_GET['ordenar']) : '';
    $desarrollador = isset($_GET['desarrollador']) ? mysqli_real_escape_string($con, $_GET['desarrollador']) : '';
    $rating = isset($_GET['rating']) ? mysqli_real_escape_string($con, $_GET['rating']) : '';

    // Start base query
    $sql = "SELECT * FROM juegos WHERE TRUE";

    // Add filters
    if ($busqueda !== '') {
        $sql .= " AND titulo LIKE '%$busqueda%'";
    }
    if ($desarrollador !== '') {
        $sql .= " AND desarrollador = '$desarrollador'";
    }
    if ($rating !== '') {
        $sql .= " AND ESRB = '$rating'";
    }

    // Add ordering
    switch ($ordenar) {
        case 'Z-A':
            $sql .= " ORDER BY titulo DESC";
            break;
        case 'Price (Desc)':
            $sql .= " ORDER BY precio DESC";
            break;
        case 'Price (Asc)':
            $sql .= " ORDER BY precio";
            break;
        default:
            $sql .= " ORDER BY titulo";
            break;
    }

    $result = mysqli_query($con, $sql);

    if (!$result) {
        http_response_code(500);
        echo json_encode(["error" => "Query failed: " . mysqli_error($con)]);
        exit;
    }

    $juegos = [];
    while ($row = mysqli_fetch_assoc($result)) {
        if (isset($row['portada'])) {
            $row['portada'] = base64_encode($row['portada']);
        }
        $juegos[] = $row;
    }

    echo json_encode($juegos);
    mysqli_close($con);
?>