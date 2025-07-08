<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *"); // Adjust as necessary for your use case
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

require_once "db.php"; // Ensure this contains your database connection

$data = json_decode(file_get_contents("php://input"));

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    if (!empty($data->username) && !empty($data->password)) {
        $username = htmlspecialchars($data->username);
        $password = $data->password;

        try {
            // Prepare the statement to prevent SQL injection
            $stmt = $conn->prepare("SELECT * FROM users WHERE username = :username");
            $stmt->bindParam(":username", $username);
            $stmt->execute();

            $user = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($user && password_verify($password, $user["password"])) {
                // Successful login
                http_response_code(200); // OK
                echo json_encode([
                    "status" => "success",
                    "message" => "Login successful",
                    "user" => [
                        "id" => $user["id"],
                        "email" => $user["email"],
                        "username" => $user["username"],
                    ]
                ]);
            } else {
                // Invalid username or password
                http_response_code(401); // Unauthorized
                echo json_encode([
                    "status" => "error",
                    "message" => "Invalid username or password"
                ]);
            }
        } catch (PDOException $e) {
            // Handle database connection errors
            http_response_code(500); // Internal Server Error
            echo json_encode([
                "status" => "error",
                "message" => "Database error: " . $e->getMessage()
            ]);
        }
    } else {
        // Missing fields
        http_response_code(400); // Bad Request
        echo json_encode([
            "status" => "error",
            "message" => "All fields are required"
        ]);
    }
}
?>
