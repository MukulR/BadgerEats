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
		if (array_key_exists("deviceID", $data) && array_key_exists("foodID", $data) && array_key_exists("foodName", $data) && array_key_exists("rating", $data)) {

			$checkQuery = "SELECT * FROM $tablename WHERE `deviceID` = ? AND `foodID` = ?";
			$selectStmt = mysqli_prepare($connection, $checkQuery);
			mysqli_stmt_bind_param($selectStmt, "si", $data['deviceID'], $data['foodID']);
			mysqli_stmt_execute($selectStmt);
			$result = mysqli_stmt_get_result($selectStmt);

			if (mysqli_num_rows($result) > 0) {
				// Row already exists, perform an update
				$updateQuery = "UPDATE $tablename SET `rating` = ?, `unixtime` = ? WHERE `deviceID` = ? AND `foodID` = ?";
				$updateStmt = mysqli_prepare($connection, $updateQuery);
				mysqli_stmt_bind_param($updateStmt, "iisi", $data['rating'], time(), $data['deviceID'], $data['foodID']);

				if (mysqli_stmt_execute($updateStmt)) {
					header('Content-Type: application/json');
					echo json_encode(array(
						"status" => "success",
					));
				} else {
					http_response_code(400);
				}

				mysqli_stmt_close($updateStmt);
			} else {
				// Row doesn't exist, perform an insert
				$insertQuery = "INSERT INTO $tablename (`deviceID`, `foodID`, `foodName`, `rating`, `unixtime`) VALUES (?, ?, ?, ?, ?)";
				$insertStmt = mysqli_prepare($connection, $insertQuery);
				mysqli_stmt_bind_param($insertStmt, "sisii", $data['deviceID'], $data['foodID'], $data["foodName"], $data['rating'], time());

				if (mysqli_stmt_execute($insertStmt)) {
					header('Content-Type: application/json');
					echo json_encode(array(
						"status" => "success",
					));
				} else {
					http_response_code(400);
				}

				mysqli_stmt_close($insertStmt);
			}

			mysqli_stmt_close($selectStmt);

		} else {
			http_response_code(400);
		}
	} else {
		echo("Unauthorized.");
		http_response_code(401);
	}
} else {
	die("Connection aborted");
}

?>