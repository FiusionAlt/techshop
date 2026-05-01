<?php
session_start();
require_once 'config.php';

header('Content-Type: application/json');

$method = $_SERVER['REQUEST_METHOD'];
$action = $_GET['action'] ?? '';

// Helper to send JSON response
function jsonResponse($data, $code = 200) {
    http_response_code($code);
    echo json_encode($data);
    exit;
}

// Helper to get request body
function getBody() {
    return json_decode(file_get_contents('php://input'), true) ?: [];
}

// -------------------- ROUTING --------------------
try {
    switch ($action) {

        // ---- SESSION: get/set current customer ----
        case 'session':
            if ($method === 'GET') {
                $customerId = $_SESSION['customer_id'] ?? null;
                $customer = null;
                if ($customerId) {
                    $stmt = $pdo->prepare("SELECT id, first_name, last_name, email, city FROM customers WHERE id = ?");
                    $stmt->execute([$customerId]);
                    $customer = $stmt->fetch();
                }
                jsonResponse(['customer_id' => $customerId, 'customer' => $customer]);
            }
            elseif ($method === 'POST') {
                $body = getBody();
                $id = $body['customer_id'] ?? null;
                if ($id) {
                    $_SESSION['customer_id'] = (int)$id;
                    jsonResponse(['success' => true, 'customer_id' => $id]);
                } else {
                    jsonResponse(['error' => 'customer_id required'], 400);
                }
            }
            break;

        // ---- CATEGORIES ----
        case 'categories':
            if ($method === 'GET') {
                $stmt = $pdo->query("SELECT * FROM categories ORDER BY name");
                jsonResponse($stmt->fetchAll());
            }
            break;

        // ---- PRODUCTS ----
        case 'products':
            if ($method === 'GET') {
                $categoryId = $_GET['category_id'] ?? null;
                $search = $_GET['search'] ?? '';
                $sql = "SELECT p.*, c.name AS category_name 
                        FROM products p 
                        JOIN categories c ON p.category_id = c.id 
                        WHERE 1=1";
                $params = [];
                if ($categoryId) {
                    $sql .= " AND p.category_id = ?";
                    $params[] = $categoryId;
                }
                if ($search) {
                    $sql .= " AND (p.name LIKE ? OR p.description LIKE ?)";
                    $params[] = "%$search%";
                    $params[] = "%$search%";
                }
                $sql .= " ORDER BY p.name";
                $stmt = $pdo->prepare($sql);
                $stmt->execute($params);
                jsonResponse($stmt->fetchAll());
            }
            break;

        // ---- CUSTOMERS ----
        case 'customers':
            if ($method === 'GET') {
                $stmt = $pdo->query("SELECT id, first_name, last_name, email, phone, city FROM customers ORDER BY last_name");
                jsonResponse($stmt->fetchAll());
            }
            elseif ($method === 'POST') {
                // Register new customer
                $body = getBody();
                $required = ['first_name', 'last_name', 'email', 'phone', 'city'];
                foreach ($required as $field) {
                    if (empty($body[$field])) {
                        jsonResponse(['error' => "Field $field is required"], 400);
                    }
                }
                $stmt = $pdo->prepare("INSERT INTO customers (first_name, last_name, email, phone, city, registration_date) 
                                       VALUES (?, ?, ?, ?, ?, CURDATE())");
                $stmt->execute([
                    $body['first_name'],
                    $body['last_name'],
                    $body['email'],
                    $body['phone'],
                    $body['city']
                ]);
                $newId = $pdo->lastInsertId();
                $_SESSION['customer_id'] = (int)$newId;  // auto-login after registration
                jsonResponse(['success' => true, 'customer_id' => $newId], 201);
            }
            break;

        // ---- ORDERS ----
        case 'orders':
            if ($method === 'GET') {
                // View orders for the current customer
                $customerId = $_SESSION['customer_id'] ?? null;
                if (!$customerId) {
                    jsonResponse(['error' => 'Not logged in. Please select a customer.'], 401);
                }
                $stmt = $pdo->prepare("SELECT o.*, 
                                              (SELECT GROUP_CONCAT(p.name, ' (', oi.quantity, ')') 
                                               FROM order_items oi 
                                               JOIN products p ON p.id = oi.product_id 
                                               WHERE oi.order_id = o.id) AS items
                                       FROM orders o 
                                       WHERE o.customer_id = ? 
                                       ORDER BY o.order_date DESC");
                $stmt->execute([$customerId]);
                $orders = $stmt->fetchAll();
                jsonResponse($orders);
            }
            elseif ($method === 'POST') {
                // Place a new order
                $customerId = $_SESSION['customer_id'] ?? null;
                if (!$customerId) {
                    jsonResponse(['error' => 'Not logged in. Please select a customer first.'], 401);
                }
                $body = getBody();
                $cartItems = $body['cart'] ?? [];
                if (empty($cartItems)) {
                    jsonResponse(['error' => 'Cart is empty'], 400);
                }

                $pdo->beginTransaction();
                try {
                    // Calculate total and validate stock
                    $total = 0;
                    $itemsToInsert = [];
                    foreach ($cartItems as $item) {
                        $stmt = $pdo->prepare("SELECT id, price, stock FROM products WHERE id = ? FOR UPDATE");
                        $stmt->execute([$item['product_id']]);
                        $product = $stmt->fetch();
                        if (!$product) {
                            throw new Exception("Product ID {$item['product_id']} not found");
                        }
                        if ($product['stock'] < $item['quantity']) {
                            throw new Exception("Insufficient stock for '{$product['id']}' (only {$product['stock']} left)");
                        }
                        $lineTotal = $product['price'] * $item['quantity'];
                        $total += $lineTotal;
                        $itemsToInsert[] = [
                            'product_id' => $product['id'],
                            'quantity' => $item['quantity'],
                            'unit_price' => $product['price']
                        ];
                        // Decrease stock
                        $stmt = $pdo->prepare("UPDATE products SET stock = stock - ? WHERE id = ?");
                        $stmt->execute([$item['quantity'], $product['id']]);
                    }

                    // Insert order
                    $stmt = $pdo->prepare("INSERT INTO orders (customer_id, order_date, total_amount, status) VALUES (?, CURDATE(), ?, 'Processing')");
                    $stmt->execute([$customerId, $total]);
                    $orderId = $pdo->lastInsertId();

                    // Insert order items
                    $stmt = $pdo->prepare("INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES (?, ?, ?, ?)");
                    foreach ($itemsToInsert as $it) {
                        $stmt->execute([$orderId, $it['product_id'], $it['quantity'], $it['unit_price']]);
                    }

                    $pdo->commit();
                    jsonResponse(['success' => true, 'order_id' => $orderId, 'total' => $total], 201);
                } catch (Exception $e) {
                    $pdo->rollBack();
                    jsonResponse(['error' => $e->getMessage()], 400);
                }
            }
            break;

        default:
            jsonResponse(['error' => 'Unknown action'], 404);
    }
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
}
?>