<?php
// Allow from any origin
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
header("Access-Control-Max-Age: 3600");

require_once 'connect.php';

// Remove preflight handling and ensure only POST requests are allowed
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode([
        'code' => 0,
        'message' => 'Method Not Allowed. Use POST with JSON data.'
    ]);
    exit();
}

// Read JSON input
$input = json_decode(file_get_contents('php://input'), true);
$fullname = $input['fullname'] ?? '';
$email = $input['email'] ?? '';
$password = $input['password'] ?? '';

if (empty($fullname) || empty($email) || empty($password)) {
    echo json_encode([
        'code' => 0,
        'message' => 'All fields are required.'
    ]);
    exit();
}

// Use prepared statements to prevent SQL injection
$stmt = $con->prepare('SELECT email FROM Users WHERE email = ?');
$stmt->bind_param('s', $email);
$stmt->execute();
$stmt->store_result();
if ($stmt->num_rows > 0) {
    echo json_encode([
        'code' => 0,
        'message' => 'Email already registered.'
    ]);
    $stmt->close();
    $con->close();
    exit();
}
$stmt->close();

$hashedPassword = password_hash($password, PASSWORD_DEFAULT);
$insertStmt = $con->prepare('INSERT INTO Users (fullname, email, password) VALUES (?, ?, ?)');
$insertStmt->bind_param('sss', $fullname, $email, $hashedPassword);

// Update success response to include 'code' key
if ($insertStmt->execute()) {
    echo json_encode([
        'code' => 1,
        'message' => 'Registration successful.',
        'fullname' => $fullname,
        'email' => $email
    ]);
} else {
    echo json_encode([
        'code' => 0,
        'message' => 'Error in registration: ' . $con->error
    ]);
}

$insertStmt->close();
$con->close();
?>
