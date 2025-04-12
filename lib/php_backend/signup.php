<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Access-Control-Allow-Origin, Accept");
require_once 'connect.php';

// Get user input from POST request
$fullname = $_GET['fullname'];
$email = $_GET['email'];
$password = md5($_GET['password']);


// Check if the email already exists
$checkEmailQuery = mysqli_query($con, "SELECT email FROM Users WHERE email = '$email'");
if (mysqli_num_rows($checkEmailQuery) > 0) {
    // Email already exists
    echo json_encode([
        'code' => 0,
        'message' => 'Email already registered.'
    ]);
} else {
    // Insert user into database
    $insertQuery = "INSERT INTO Users (fullname, email, password ) 
                    VALUES ('$fullname', '$email', '$password')";

    if (mysqli_query($con, $insertQuery)) {
        // Return success response
        echo json_encode([
            'code' => 1,
            'message' => 'Registration successful.'
        ]);
    } else {
        // Return error response
        echo json_encode([
            'code' => 0,
            'message' => 'Error in registration: ' . mysqli_error($con)
        ]);
    }
}

// Close the database connection
mysqli_close($con);
?>
