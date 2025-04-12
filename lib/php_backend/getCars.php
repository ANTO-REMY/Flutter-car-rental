<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Access-Control-Allow-Origin, Accept");

require_once 'connect.php';

$query = "SELECT car_id, carname, model, price, description, fuel FROM Cars";
$result = mysqli_query($con, $query);

if ($result) {
    if (mysqli_num_rows($result) > 0) {
        $cars = [];
        while ($row = mysqli_fetch_assoc($result)) {
            $cars[] = [
                'id' => $row['car_id'],
                'carname' => $row['carname'],
                'model' => $row['model'],
                'price' => (float)$row['price'],
                'description' => $row['description'],
                'fuel' => $row['fuel']
            ];
        }
        
        echo json_encode([
            'status' => 'success',
            'cars' => $cars
        ]);
    } else {
        echo json_encode([
            'status' => 'error',
            'message' => 'No cars found'
        ]);
    }
} else {
    echo json_encode([
        'status' => 'error',
        'message' => 'Database query failed: ' . mysqli_error($con)
    ]);
}

mysqli_close($con);
?>