<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
header("Content-Type: application/json; charset=UTF-8");

include 'connect.php';

if (!empty($_GET['car_name']) && !empty($_GET['payment_method']) && !empty($_GET['booking_id'])) {
    $car_name = mysqli_real_escape_string($con, $_GET['car_name']);
    $payment_method = mysqli_real_escape_string($con, $_GET['payment_method']);
    $booking_id = mysqli_real_escape_string($con, $_GET['booking_id']);
    $payment_status = 'PENDING';

    $sql = "INSERT INTO OrderTable (booking_id, car_name, payment_method, payment_status) 
            VALUES ('$booking_id', '$car_name', '$payment_method', '$payment_status')";

    $result = mysqli_query($con, $sql);

    if ($result) {
        echo json_encode([
            "success" => true,
            "message" => "Order created successfully"
        ]);
    } else {
        echo json_encode([
            "success" => false,
            "message" => "Failed to create order"
        ]);
    }
} else {
    echo json_encode([
        "success" => false,
        "message" => "All fields are required"
    ]);
}
?>