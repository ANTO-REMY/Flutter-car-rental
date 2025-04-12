<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Access-Control-Allow-Origin, Accept");

require_once 'connect.php';

// Check if email parameter is provided
if (!isset($_GET['email'])) {
    echo json_encode([
        'code' => 0,
        'message' => 'Email parameter is required'
    ]);
    exit;
}

// Sanitize the email input
$email = mysqli_real_escape_string($con, $_GET['email']);

// Query to fetch user information
$query = "SELECT fullname, email FROM Users WHERE email = '$email'";
$result = mysqli_query($con, $query);

if ($result) {
    if (mysqli_num_rows($result) > 0) {
        $user = mysqli_fetch_assoc($result);
        echo json_encode([
            'code' => 1,
            'message' => 'User found',
            'data' => [
                'fullname' => $user['fullname'],
                'email' => $user['email']
            ]
        ]);
    } else {
        echo json_encode([
            'code' => 0,
            'message' => 'User not found'
        ]);
    }
} else {
    echo json_encode([
        'code' => 0,
        'message' => 'Query failed: ' . mysqli_error($con)
    ]);
}

mysqli_close($con);
?>