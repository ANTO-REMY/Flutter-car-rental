<?php
// Set headers for CORS and JSON response
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Access-Control-Allow-Origin, Accept, Content-Type");

// Include database connection
require_once 'connect.php';

// Check if the database connection was successful
if (!$con) {
    echo json_encode([
        "success" => 0,
        "message" => "Failed to connect to database: " . mysqli_connect_error()
    ]);
    exit;
}

// Handle GET request
if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    // Display a form to the user to input booking details
    echo json_encode([
        "success" => 1,
        "message" => "Please provide booking details",
        "form" => [
            "fields" => [
                "start_date",
                "end_date",
                "customer_name",
                "customer_phone",
                "customer_email"
            ]
        ]
    ]);
    exit;
}

// Handle POST request
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Fetch input parameters from the request body
    $input = json_decode(file_get_contents('php://input'), true);

    // Validate input
    $errors = [];
    if (empty($input['start_date'])) $errors[] = "Start date is required";
    if (empty($input['end_date'])) $errors[] = "End date is required";
    if (empty($input['customer_name'])) $errors[] = "Customer name is required";
    if (empty($input['customer_phone'])) $errors[] = "Customer phone is required";
    if (empty($input['customer_email'])) $errors[] = "Customer email is required";

    // If there are validation errors, return them
    if (!empty($errors)) {
        echo json_encode([
            "success" => 0,
            "message" => "Validation failed",
            "errors" => $errors
        ]);
        exit;
    }

    // Validate email format
    if (!filter_var($input['customer_email'], FILTER_VALIDATE_EMAIL)) {
        echo json_encode([
            "success" => 0,
            "message" => "Invalid email format"
        ]);
        exit;
    }

    // Prepare SQL query
    $sql = "INSERT INTO Booking (start_date, end_date, customer_name, customer_phone, customer_email, status) 
            VALUES (?, ?, ?, ?, ?, ?)";

    // Prepare statement
    $stmt = $con->prepare($sql);
    if ($stmt === false) {
        echo json_encode([
            "success" => 0,
            "message" => "SQL preparation error: " . $con->error
        ]);
        exit;
    }

    // Bind parameters 
    $stmt->bind_param("ssssss", $input['start_date'], $input['end_date'], $input['customer_name'], $input['customer_phone'], $input['customer_email'], 'PENDING');

    // Execute query
    if ($stmt->execute()) {
        echo json_encode([
            "success" => 1,
            "message" => "Booking created successfully",
            "booking_id" => $stmt->insert_id
        ]);
    } else {
        echo json_encode([
            "success" => 0,
            "message" => "Failed to create booking",
            "error" => $stmt->error
        ]);
    }

    // Close statement
    $stmt->close();
} else {
    echo json_encode([
        "success" => 0,
        "message" => "Invalid request method. Use POST."
    ]);
}

// Close connection
$con->close();
?>