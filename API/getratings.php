<?php

$sname = "localhost";
$uname = "root";
$pwd = "";
$dbname = "badgereats";
$tablename = "reviews";
$apikey = "";

$jsonContent = file_get_contents('authorization.json');
$jsonData = json_decode($jsonContent, true);

if ($jsonData === null) {
    echo "Error parsing Auth.";
} else {
    // Access the value using the key 'main'
    $pwd = $jsonData['dbpwd'];
}

$connection = mysqli_connect($sname, $uname, $pwd, $dbname);

function getData() {
    global $connection;
    
    $query = "SELECT foodID, AVG(rating) AS average_rating FROM reviews GROUP BY foodID";
    $result = mysqli_query($connection, $query);
    
    if (!$result) {
        return null; // Return null or handle the error as needed
    }
    
    $foodReviews = array();
    while ($row = mysqli_fetch_assoc($result)) {
        $foodID = $row['foodID'];
        $averageRating = $row['average_rating'];
        
        $foodReviews[$foodID] = $averageRating;
    }
    
    return $foodReviews;
}

$data = getData($deviceID);
// Set the Content-Type header to JSON
header('Content-Type: application/json');
// Echo the JSON-encoded data
echo json_encode(array("ratings" => $data));
?>