<?php

// ini_set('display_errors', 1);
// ini_set('display_startup_errors', 1);
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
error_reporting(E_ALL);


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

if($connection) {
	$data = json_decode(file_get_contents('php://input'), true);
	$headers = getallheaders();
	if (strcmp(trim($headers["api-key"]), trim($apikey)) == 0) {
		if (array_key_exists("deviceID", $data) && array_key_exists("foodID", $data) && array_key_exists("rating", $data)) {

			$insertQuery = "INSERT INTO $tablename (`deviceID`, `foodID`, `rating`) VALUES (?, ?, ?)";
			$stmt = mysqli_prepare($connection, $insertQuery);
			if ($stmt) {
				mysqli_stmt_bind_param($stmt, "sii", $data['deviceID'], $data['foodID'], $data['rating']);
				if (mysqli_stmt_execute($stmt)) {
					header('Content-Type: application/json');
					echo json_encode(array(
						"status" => "success",
					));
				} else {
					echo("fail");
					http_response_code(400);
				}
				mysqli_stmt_close($stmt);
			} else {
				echo("failst");
				http_response_code(400);
			}
		} else {
			echo("fail2");
			http_response_code(400);
		}
	} else {
		echo("fail3");
		http_response_code(401);
	}
} else {
	die("Connection aborted");
}

?>