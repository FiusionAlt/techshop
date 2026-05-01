CREATE DATABASE IF NOT EXISTS techshop CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE techshop;

CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT
) ENGINE=InnoDB;

INSERT INTO categories (name, description) VALUES
('Laptops', 'Notebooks and ultrabooks'),
('Smartphones', 'Mobile phones and accessories'),
('Monitors', 'Displays and screens'),
('Keyboards', 'Mechanical and membrane keyboards'),
('Mice', 'Gaming and office mice'),
('Headphones', 'Audio devices'),
('Storage', 'SSD, HDD, USB drives'),
('RAM', 'Memory modules'),
('Graphics Cards', 'GPU units'),
('Motherboards', 'Mainboards'),
('Power Supplies', 'PSU units'),
('Cases', 'PC cases and chassis'),
('Cooling', 'Fans and liquid cooling'),
('Printers', 'Printing devices'),
('Networking', 'Routers, switches, adapters'),
('Software', 'Licenses and subscriptions'),
('Cables', 'Connectors and adapters'),
('Webcams', 'Cameras for streaming'),
('Speakers', 'External audio systems'),
('Accessories', 'Various accessories');

CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    category_id INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    description TEXT,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

INSERT INTO products (name, category_id, price, stock, description) VALUES
('Dell XPS 15', 1, 1499.99, 25, '15.6" 4K OLED, Intel i7-13700H, 16GB RAM, 512GB SSD'),
('MacBook Air M2', 1, 1199.00, 30, '13.6" Retina, Apple M2, 8GB RAM, 256GB SSD'),
('Lenovo ThinkPad X1', 1, 1349.00, 18, '14" IPS, Intel i7-1365U, 16GB RAM, 512GB SSD'),
('iPhone 15 Pro', 2, 999.00, 40, '6.1" OLED, A17 Pro, 256GB, Titanium'),
('Samsung Galaxy S24', 2, 859.00, 35, '6.2" Dynamic AMOLED, Snapdragon 8 Gen3, 256GB'),
('Google Pixel 8', 2, 699.00, 22, '6.2" OLED, Tensor G3, 128GB, AI features'),
('LG 27" 4K Monitor', 3, 449.00, 20, '27" IPS 4K UHD, HDR10, USB-C, 60Hz'),
('Samsung Odyssey G9', 3, 1299.00, 8, '49" Curved QLED, 240Hz, 5120x1440, Gaming'),
('Dell UltraSharp 32"', 3, 799.00, 15, '32" IPS 4K, Factory Calibrated, USB-C Hub'),
('Logitech MX Keys', 4, 99.99, 50, 'Wireless illuminated keyboard, USB-C, multi-device'),
('Corsair K95 RGB', 4, 179.00, 28, 'Mechanical gaming keyboard, Cherry MX Blue, RGB'),
('Keychron K8 Pro', 4, 109.00, 33, 'Wireless mechanical, hot-swappable, aluminum frame'),
('Logitech MX Master 3S', 5, 94.99, 45, 'Ergonomic wireless mouse, 8000 DPI, USB-C'),
('Razer DeathAdder V3', 5, 69.99, 38, 'Gaming mouse, 30K DPI optical sensor, lightweight'),
('Sony WH-1000XM5', 6, 349.00, 25, 'Wireless noise-cancelling headphones, 30h battery'),
('AirPods Pro 2', 6, 249.00, 55, 'Active noise cancellation, spatial audio, H2 chip'),
('Samsung 990 Pro 2TB', 7, 179.00, 40, 'NVMe M.2 SSD, 7450MB/s read, PCIe 4.0'),
('WD Black 4TB HDD', 7, 129.00, 22, '3.5" 7200RPM, 256MB cache, SATA III'),
('SanDisk USB 128GB', 7, 19.99, 100, 'USB 3.2 Flash Drive, 400MB/s read'),
('Corsair Vengeance 32GB', 8, 109.00, 35, 'DDR5 6000MHz, CL30, 2x16GB kit'),
('G.Skill Trident Z5 64GB', 8, 219.00, 15, 'DDR5 6400MHz, CL32, 2x32GB, RGB'),
('NVIDIA RTX 4070', 9, 599.00, 12, '12GB GDDR6X, DLSS 3, Ray Tracing'),
('AMD Radeon RX 7800 XT', 9, 499.00, 10, '16GB GDDR6, RDNA 3, 256-bit'),
('ASUS ROG Strix B650', 10, 229.00, 18, 'AM5, DDR5, PCIe 5.0, WiFi 6E, ATX'),
('MSI MAG B760', 10, 159.00, 25, 'LGA1700, DDR5, PCIe 5.0, mATX'),
('Corsair RM850x', 11, 139.00, 30, '850W, 80+ Gold, Fully Modular, Silent'),
('NZXT H7 Flow', 12, 129.00, 20, 'Mid-tower, tempered glass, high airflow'),
('Noctua NH-D15', 13, 99.00, 22, 'Dual tower CPU cooler, 140mm fans'),
('TP-Link Archer AX73', 15, 119.00, 28, 'WiFi 6 Router, 5400Mbps, OFDMA'),
('Logitech C920 Webcam', 18, 79.99, 45, '1080p HD Pro, dual microphones, autofocus');

CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    city VARCHAR(50),
    registration_date DATE NOT NULL
) ENGINE=InnoDB;

INSERT INTO customers (first_name, last_name, email, phone, city, registration_date) VALUES
('Ivan', 'Horvat', 'ivan.horvat@email.hr', '091-123-4001', 'Zagreb', '2024-01-15'),
('Ana', 'Kovačić', 'ana.kovacic@email.hr', '092-234-5002', 'Split', '2024-01-20'),
('Marko', 'Babić', 'marko.babic@email.hr', '095-345-6003', 'Rijeka', '2024-02-03'),
('Petra', 'Novak', 'petra.novak@email.hr', '091-456-7004', 'Osijek', '2024-02-10'),
('Luka', 'Marić', 'luka.maric@email.hr', '098-567-8005', 'Zadar', '2024-02-18'),
('Maja', 'Jurić', 'maja.juric@email.hr', '091-678-9006', 'Dubrovnik', '2024-03-01'),
('Tomislav', 'Vuković', 'tomislav.vukovic@email.hr', '092-789-1007', 'Pula', '2024-03-10'),
('Sara', 'Knežević', 'sara.knezevic@email.hr', '095-890-2008', 'Šibenik', '2024-03-15'),
('Filip', 'Đurić', 'filip.djuric@email.hr', '091-901-3009', 'Varaždin', '2024-03-22'),
('Martina', 'Pavlović', 'martina.pavlovic@email.hr', '098-012-4010', 'Karlovac', '2024-04-01'),
('Davor', 'Tomić', 'davor.tomic@email.hr', '091-111-5011', 'Slavonski Brod', '2024-04-08'),
('Iva', 'Radić', 'iva.radic@email.hr', '092-222-6012', 'Zagreb', '2024-04-15'),
('Nikola', 'Božić', 'nikola.bozic@email.hr', '095-333-7013', 'Split', '2024-04-20'),
('Katarina', 'Šarić', 'katarina.saric@email.hr', '091-444-8014', 'Rijeka', '2024-05-02'),
('Goran', 'Perić', 'goran.peric@email.hr', '098-555-9015', 'Zagreb', '2024-05-10'),
('Elena', 'Grgić', 'elena.grgic@email.hr', '091-666-1016', 'Osijek', '2024-05-18'),
('Ante', 'Blažević', 'ante.blazevic@email.hr', '092-777-2017', 'Zadar', '2024-06-01'),
('Lucija', 'Mandić', 'lucija.mandic@email.hr', '095-888-3018', 'Dubrovnik', '2024-06-10'),
('Krešimir', 'Kovač', 'kresimir.kovac@email.hr', '091-999-4019', 'Pula', '2024-06-20'),
('Nina', 'Horvatinčić', 'nina.horvatincic@email.hr', '098-101-5020', 'Varaždin', '2024-07-01'),
('Stjepan', 'Matić', 'stjepan.matic@email.hr', '091-202-6021', 'Zagreb', '2024-07-15'),
('Tea', 'Filipović', 'tea.filipovic@email.hr', '092-303-7022', 'Split', '2024-08-01'),
('Josip', 'Lovrić', 'josip.lovric@email.hr', '095-404-8023', 'Rijeka', '2024-08-20'),
('Marta', 'Kralj', 'marta.kralj@email.hr', '091-505-9024', 'Karlovac', '2024-09-05'),
('Zvonimir', 'Šimić', 'zvonimir.simic@email.hr', '098-606-1025', 'Zagreb', '2024-09-20');

CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'Processing',
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

INSERT INTO orders (id, customer_id, order_date, total_amount, status) VALUES
(1, 1, '2024-01-25', 1499.99, 'Delivered'),
(2, 2, '2024-02-05', 999.00, 'Delivered'),
(3, 3, '2024-02-15', 449.00, 'Delivered'),
(4, 4, '2024-03-01', 1299.00, 'Shipped'),
(5, 5, '2024-03-10', 179.00, 'Delivered'),
(6, 6, '2024-03-20', 109.00, 'Delivered'),
(7, 7, '2024-04-01', 349.00, 'Shipped'),
(8, 8, '2024-04-10', 249.00, 'Delivered'),
(9, 9, '2024-04-20', 179.00, 'Processing'),
(10, 10, '2024-05-01', 129.00, 'Delivered'),
(11, 11, '2024-05-10', 109.00, 'Shipped'),
(12, 12, '2024-05-20', 599.00, 'Processing'),
(13, 13, '2024-06-01', 499.00, 'Delivered'),
(14, 14, '2024-06-15', 229.00, 'Shipped'),
(15, 15, '2024-07-01', 139.00, 'Delivered'),
(16, 16, '2024-07-15', 119.00, 'Processing'),
(17, 17, '2024-08-01', 109.00, 'Delivered'),
(18, 18, '2024-08-15', 219.00, 'Shipped'),
(19, 19, '2024-09-01', 79.99, 'Delivered'),
(20, 20, '2024-09-10', 1199.00, 'Processing'),
(21, 21, '2024-09-20', 859.00, 'Shipped'),
(22, 22, '2024-10-01', 699.00, 'Delivered'),
(23, 23, '2024-10-10', 159.00, 'Processing'),
(24, 24, '2024-10-20', 139.00, 'Shipped'),
(25, 25, '2024-11-01', 119.00, 'Processing'),
(26, 1, '2024-11-02', 99.99, 'Processing'),
(27, 2, '2024-11-03', 189.98, 'Processing'),
(28, 3, '2024-11-04', 59.97, 'Processing'),
(29, 4, '2024-11-05', 99.00, 'Processing'),
(30, 5, '2024-11-06', 249.00, 'Processing'),
(31, 6, '2024-11-07', 94.99, 'Processing'),
(32, 7, '2024-11-08', 99.99, 'Processing');

CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 1499.99),
(2, 4, 1, 999.00),
(3, 7, 1, 449.00),
(4, 8, 1, 1299.00),
(5, 11, 1, 179.00),
(6, 20, 1, 109.00),
(7, 15, 1, 349.00),
(8, 16, 1, 249.00),
(9, 17, 1, 179.00),
(10, 18, 1, 129.00),
(11, 20, 1, 109.00),
(12, 22, 1, 599.00),
(13, 23, 1, 499.00),
(14, 24, 1, 229.00),
(15, 26, 1, 139.00),
(16, 29, 1, 119.00),
(17, 12, 1, 109.00),
(18, 21, 1, 219.00),
(19, 30, 1, 79.99),
(20, 2, 1, 1199.00),
(21, 5, 1, 859.00),
(22, 6, 1, 699.00),
(23, 25, 1, 159.00),
(24, 26, 1, 139.00),
(25, 29, 1, 119.00),
(26, 10, 1, 99.99),
(27, 13, 2, 94.99),
(28, 19, 3, 19.99),
(29, 28, 1, 99.00),
(30, 16, 1, 249.00),
(31, 13, 1, 94.99),
(32, 10, 1, 99.99);

UPDATE order_items SET product_id = 10 WHERE id = 26;
UPDATE order_items SET product_id = 13 WHERE id = 27;
UPDATE order_items SET product_id = 19 WHERE id = 28;
UPDATE order_items SET product_id = 28 WHERE id = 29;
UPDATE order_items SET product_id = 16 WHERE id = 30;
UPDATE order_items SET product_id = 13 WHERE id = 31;
UPDATE order_items SET product_id = 10 WHERE id = 32;

CREATE TABLE reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    customer_id INT NOT NULL,
    rating TINYINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    review_date DATE NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
) ENGINE=InnoDB;

INSERT INTO reviews (product_id, customer_id, rating, comment, review_date) VALUES
(1, 1, 5, 'Excellent laptop, very fast!', '2024-02-01'),
(1, 15, 4, 'Great display, battery could be better.', '2024-07-10'),
(4, 2, 5, 'Best iPhone yet!', '2024-02-10'),
(4, 22, 5, 'Amazing camera system.', '2024-10-05'),
(7, 3, 4, 'Sharp 4K, great for work.', '2024-02-20'),
(8, 4, 5, 'Immersive gaming experience!', '2024-03-10'),
(11, 5, 4, 'Solid mechanical keyboard.', '2024-03-20'),
(15, 7, 5, 'Best noise cancelling ever.', '2024-04-10'),
(16, 8, 5, 'Perfect fit, great sound.', '2024-04-20'),
(17, 9, 5, 'Blazing fast SSD!', '2024-05-01'),
(18, 10, 3, 'Good for backups, a bit noisy.', '2024-05-10'),
(22, 12, 5, 'RTX 4070 is a beast for 1440p.', '2024-06-01'),
(23, 13, 4, 'Great value AMD card.', '2024-06-10'),
(24, 14, 5, 'Stable motherboard, easy BIOS.', '2024-06-20'),
(26, 15, 5, 'Silent and efficient PSU.', '2024-07-10'),
(29, 16, 4, 'Good WiFi coverage.', '2024-07-20'),
(2, 20, 5, 'M2 chip is incredible.', '2024-09-15'),
(5, 21, 4, 'Smooth performance.', '2024-09-25'),
(6, 22, 5, 'Pixel camera is unmatched.', '2024-10-10'),
(10, 1, 5, 'Best keyboard for productivity.', '2024-02-05'),
(13, 4, 5, 'Ergonomic perfection.', '2024-03-05'),
(19, 7, 4, 'Fast USB drive, good price.', '2024-04-05'),
(28, 12, 5, 'Keeps CPU ice cold.', '2024-05-25'),
(30, 19, 4, 'Good webcam for meetings.', '2024-09-10'),
(27, 24, 5, 'Great airflow case.', '2024-10-25');