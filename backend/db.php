<?php
$host = "localhost";
$db_name = "rona_malang";
$username = "root";
$password = "";
$port = "3308";

try {
    $conn = new PDO("mysql:host=$host;port=$port;dbname=$db_name", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die(json_encode(['error' => $e->getMessage()]));
}
?>