<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Access-Control-Allow-Origin, Accept");
require_once 'connect.php';

// Use $_GET instead of $_Get (PHP is case-sensitive)
$email = $_GET['email'];
$password = md5($_GET['password']);

// Correct SQL query: remove the extra comma after "email"
$query = mysqli_query($con, "SELECT email FROM Users WHERE email = '$email' AND password = '$password'");

// Check if the query ran successfully
if (!$query) {
    echo json_encode([
        'code' => 0,
        'message' => 'Database query error: ' . mysqli_error($con)
    ]);
    mysqli_close($con);
    exit;
}

// Check if user credentials match
if (mysqli_num_rows($query) > 0) {
    // Fetch user details
    $rows = [];
    while ($row = mysqli_fetch_assoc($query)) {
        $rows[] = $row;
    }
    // Return success response with user details
    echo json_encode([
        'code' => 1,
        'userdetails' => $rows
    ]);
} else {
    // Return error response if credentials are invalid
    echo json_encode([
        'code' => 0,
        'message' => 'Invalid email or password.'
    ]);
}

// Close the database connection
mysqli_close($con);
?>
