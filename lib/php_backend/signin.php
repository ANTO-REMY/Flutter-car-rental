<?php
header('Content-Type: application/json');
require_once 'connect.php';

$data = json_decode(file_get_contents('php://input'), true);
$email = $data['email'] ?? '';
$password = $data['password'] ?? '';

if (!$email || !$password) {
    echo json_encode(['code' => 0, 'message' => 'Email and password required']);
    exit;
}

// Query user from database
$stmt = $conn->prepare("SELECT * FROM users WHERE email = ?");
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();
$user = $result->fetch_assoc();

if ($user && $user['password'] === $password) { // If you hash passwords, use password_verify()
    echo json_encode(['code' => 1, 'message' => 'Login successful']);
} else {
    echo json_encode(['code' => 0, 'message' => 'Invalid credentials']);
}
?>
