<?php
include 'db.php'; // Pastikan ini berisi koneksi database Anda

header('Content-Type: application/json');

$requestMethod = $_SERVER["REQUEST_METHOD"];

switch ($requestMethod) {
    case 'GET':
        if (isset($_GET['id'])) {
            getPlace($conn, $_GET['id']);
        } elseif (isset($_GET['category_id'])) {
            getPlacesByCategory($conn, $_GET['category_id']); // Mengambil data berdasarkan ID kategori
        } elseif (isset($_GET['get_categories'])) {
            getCategories($conn);
        } else {
            getPlaces($conn);
        }
        break;

    case 'POST':
        if (isset($_GET['create_category'])) {
            createCategory($conn);
        } else {
            createPlace($conn);
        }
        break;

    case 'PUT':
        $data = json_decode(file_get_contents("php://input"), true);
        if (isset($data['id'])) {
            updatePlace($conn, $data['id']);
        } else {
            echo json_encode(["message" => "ID is required"]);
        }
        break;

    case 'DELETE':
        $data = json_decode(file_get_contents("php://input"), true);
        if (isset($data['id'])) {
            deletePlace($conn, $data['id']);
        } else {
            echo json_encode(["message" => "ID is required"]);
        }
        break;

    default:
        http_response_code(405);
        echo json_encode(["message" => "Method not allowed"]);
        break;
}

function getBaseURL() {
    return $_SERVER['REQUEST_SCHEME'] . '://' . $_SERVER['HTTP_HOST'];
}

// Fungsi untuk mendapatkan semua tempat
// Fungsi untuk mendapatkan semua tempat
function getPlaces($conn) {
    $stmt = $conn->prepare("SELECT * FROM places");
    $stmt->execute();
    $places = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Hapus penggantian URL dan biarkan path relatif
    foreach ($places as &$place) {
        // Biarkan ini tetap sebagai nama file gambar saja
        // $place['image'] = getBaseURL() . '/' . $place['image']; // Hapus ini
    }

    echo json_encode($places);
}

// Fungsi lainnya tetap sama, hanya pastikan pengaturan gambar diambil dengan benar.


// Fungsi untuk mendapatkan tempat berdasarkan ID
function getPlace($conn, $id) {
    $stmt = $conn->prepare("SELECT * FROM places WHERE id = ?");
    $stmt->execute([$id]);
    $place = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($place) {
        $place['image'] = getBaseURL() . '/' . $place['image'];
        echo json_encode($place);
    } else {
        http_response_code(404);
        echo json_encode(["message" => "Place not found"]);
    }
}

// Fungsi untuk mendapatkan tempat berdasarkan ID kategori
function getPlacesByCategory($conn, $categoryId) {
    $stmt = $conn->prepare("SELECT * FROM places WHERE category_id = ?");
    $stmt->execute([$categoryId]);
    $places = $stmt->fetchAll(PDO::FETCH_ASSOC);

    foreach ($places as &$place) {
        // $place['image'] = getBaseURL() . '/' . $place['image'];
    }

    if ($places) {
        echo json_encode($places);
    } else {
        echo json_encode([]);
    }
}

// Fungsi untuk mendapatkan semua kategori
function getCategories($conn) {
    $stmt = $conn->prepare("SELECT * FROM categories");
    $stmt->execute();
    $categories = $stmt->fetchAll(PDO::FETCH_ASSOC);
    echo json_encode($categories);
}

// Fungsi untuk membuat tempat baru
function createPlace($conn) {
    $data = json_decode(file_get_contents("php://input"), true);

    if (!isset($data['name'], $data['location'], $data['image'], $data['category_id'], $data['rating'])) {
        http_response_code(400);
        echo json_encode(["message" => "All fields are required"]);
        return;
    }

    try {
        $stmt = $conn->prepare("INSERT INTO places (name, location, image, category_id, rating) VALUES (?, ?, ?, ?, ?)");
        $stmt->execute([$data['name'], $data['location'], $data['image'], $data['category_id'], $data['rating']]);
        echo json_encode(["message" => "Place created successfully"]);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(["error" => $e->getMessage()]);
    }
}

// Fungsi untuk memperbarui tempat yang sudah ada
function updatePlace($conn, $id) {
    $data = json_decode(file_get_contents("php://input"), true);

    if (!isset($data['name'], $data['location'], $data['image'], $data['category_id'], $data['rating'])) {
        http_response_code(400);
        echo json_encode(["message" => "All fields are required"]);
        return;
    }

    try {
        $stmt = $conn->prepare("UPDATE places SET name = ?, location = ?, image = ?, category_id = ?, rating = ? WHERE id = ?");
        $stmt->execute([$data['name'], $data['location'], $data['image'], $data['category_id'], $data['rating'], $id]);
        echo json_encode(["message" => "Place updated successfully"]);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(["error" => $e->getMessage()]);
    }
}

// Fungsi untuk menghapus tempat berdasarkan ID
function deletePlace($conn, $id) {
    try {
        $stmt = $conn->prepare("DELETE FROM places WHERE id = ?");
        $stmt->execute([$id]);
        echo json_encode(["message" => "Place deleted successfully"]);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(["error" => $e->getMessage()]);
    }
}

// Fungsi untuk membuat kategori baru
function createCategory($conn) {
    $data = json_decode(file_get_contents("php://input"), true);

    if (!isset($data['name'])) {
        http_response_code(400);
        echo json_encode(["message" => "Category name is required"]);
        return;
    }

    try {
        $stmt = $conn->prepare("INSERT INTO categories (name) VALUES (?)");
        $stmt->execute([$data['name']]);
        echo json_encode(["message" => "Category created successfully"]);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(["error" => $e->getMessage()]);
    }
}
?>
