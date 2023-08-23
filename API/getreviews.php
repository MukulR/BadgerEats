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
    $apikey = $jsonData['api-key'];
}

$connection = mysqli_connect($sname, $uname, $pwd, $dbname);

function getData($deviceID) {
    global $connection;
    
    // Sanitize the input to prevent SQL injection
    $deviceID = mysqli_real_escape_string($connection, $deviceID);
    
    // Construct the SQL query
    $query = "SELECT foodID, rating FROM reviews WHERE deviceID = '$deviceID'";
    
    // Execute the query
    $result = mysqli_query($connection, $query);
    
    // Check if the query was successful
    if ($result) {
        $data = array();
        
        // Fetch rows and create JSON array
        while ($row = mysqli_fetch_assoc($result)) {
            $foodID = $row['foodID'];
            $rating = $row['rating'];
            $data[$foodID] = $rating;
        }
        
        // Free the result set
        mysqli_free_result($result);
        
        return $data;
    } else {
        // Query execution failed
        return false;
    }
}

// Check if the required parameters are present in the URL
if (isset($_GET['deviceID'])) {
    $deviceID = urldecode($_GET['deviceID']);
    $data = getData($deviceID);

    // Set the Content-Type header to JSON
    header('Content-Type: application/json');

    // Echo the JSON-encoded data
    echo json_encode(array("ratings" => $data));
} else {
    // If required parameters are missing, return an error message
    echo(json_encode(array('error' => 'Missing parameters')));
}
?>