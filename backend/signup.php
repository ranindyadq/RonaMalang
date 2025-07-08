<?php
header("Content-Type: application/json");
require_once "db.php";

$data = json_decode(file_get_contents("php://input"));

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    if (!empty($data->email) && !empty($data->username) && !empty($data->password)) {
        $email = htmlspecialchars($data->email);
        $username = htmlspecialchars($data->username);
        $password = password_hash($data->password, PASSWORD_BCRYPT);

        try {
            $stmt = $conn->prepare("INSERT INTO users (email, username, password) VALUES (:email, :username, :password)");
            $stmt->bindParam(":email", $email);
            $stmt->bindParam(":username", $username);
            $stmt->bindParam(":password", $password);
            $stmt->execute();

            echo json_encode([
                "status" => "success",
                "message" => "User registered successfully"
            ]);
        } catch (PDOException $e) {
            // Menangani kesalahan PDO
            if ($e->getCode() == 23000) {
                echo json_encode([
                    "status" => "error",
                    "message" => "Email or Username already exists"
                ]);
            } else {
                echo json_encode([
                    "status" => "error",
                    "message" => $e->getMessage()
                ]);
            }
        } catch (Exception $e) {
            // Menangani kesalahan umum
            echo json_encode([
                "status" => "error",
                "message" => "An error occurred: " . $e->getMessage()
            ]);
        }
    } else {
        echo json_encode([
            "status" => "error",
            "message" => "All fields are required"
        ]);
    }
} elseif ($_SERVER["REQUEST_METHOD"] == "GET") {
    try {
        $stmt = $conn->prepare("SELECT id, email, username FROM users");
        $stmt->execute();
        $users = $stmt->fetchAll(PDO::FETCH_ASSOC);

        echo json_encode([
            "status" => "success",
            "data" => $users
        ]);
    } catch (PDOException $e) {
        echo json_encode([
            "status" => "error",
            "message" => $e->getMessage()
        ]);
    }
} else {
    echo json_encode([
        "status" => "error",
        "message" => "Invalid request method"
    ]);
}
?>
