<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Access-Control-Allow-Origin, Accept");

require_once 'connect.php';

// Check if required parameters are set
if (!isset($_GET['fullname']) || !isset($_GET['email']) || !isset($_GET['old_email']) || !isset($_GET['password'])) {
    echo json_encode([
        'code' => 0,
        'message' => 'Missing required parameters'
    ]);
    exit;
}

// Sanitize inputs
$fullname = mysqli_real_escape_string($con, $_GET['fullname']);
$email = mysqli_real_escape_string($con, $_GET['email']);
$old_email = mysqli_real_escape_string($con, $_GET['old_email']);
$password = md5($_GET['password']);

// Validate email format
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    echo json_encode([
        'code' => 0,
        'message' => 'Invalid email format'
    ]);
    exit;
}

// Check if old email exists
$check_query = "SELECT * FROM Users WHERE email = '$old_email'";
$result = mysqli_query($con, $check_query);

if (mysqli_num_rows($result) == 0) {
    echo json_encode([
        'code' => 0,
        'message' => 'User not found'
    ]);
    exit;
}

// If new email is different from old email, check if it's already taken
if ($email !== $old_email) {
    $email_check = "SELECT * FROM Users WHERE email = '$email'";
    $email_result = mysqli_query($con, $email_check);
    
    if (mysqli_num_rows($email_result) > 0) {
        echo json_encode([
            'code' => 0,
            'message' => 'Email already exists'
        ]);
        exit;
    }
}

// Update user details
$query = "UPDATE Users SET fullname = '$fullname', email = '$email', password = '$password' WHERE email = '$old_email'";

if (mysqli_query($con, $query)) {
    echo json_encode([
        'code' => 1,
        'message' => 'Profile updated successfully'
    ]);
} else {
    echo json_encode([
        'code' => 0,
        'message' => 'Update failed: ' . mysqli_error($con)
    ]);
}

mysqli_close($con);
?>