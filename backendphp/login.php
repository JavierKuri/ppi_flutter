<?php
    ini_set('display_errors', 1);
    error_reporting(E_ALL);
    header('Content-Type: application/json');
    include 'config.php';
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $usuario = $_POST['correo'] ?? '';
        $contra = $_POST['contra'] ?? '';
        $correo = mysqli_real_escape_string($con,$_POST['correo']);
        $contra = mysqli_real_escape_string($con,$_POST['contra']);
        $sql = "SELECT * FROM usuarios WHERE correo='${correo}' AND contrasena='${contra}';";
        $result = mysqli_query($con, $sql);

        if ($result && mysqli_num_rows($result) > 0) {
            $_SESSION['correo'] = $correo; 
            echo json_encode(['success' => true, 'message' => 'Login successful']);
        } else {
            echo json_encode(['success' => false, 'message' => 'Invalid credentials']);
        }

    } else {
        http_response_code(405);
        echo json_encode(['error' => 'Only POST method is accepted']);
    }
    mysqli_close($con);
?>