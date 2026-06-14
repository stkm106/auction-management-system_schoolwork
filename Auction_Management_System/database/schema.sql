CREATE DATABASE IF NOT EXISTS auction_management_system;
USE auction_management_system;

DROP TABLE IF EXISTS wallet_transactions;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS auction_deposits;
DROP TABLE IF EXISTS bids;
DROP TABLE IF EXISTS auctions;
DROP TABLE IF EXISTS product_images;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS wallets;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    user_id      INT PRIMARY KEY AUTO_INCREMENT,
    username     VARCHAR(100) NOT NULL UNIQUE,
    password     VARCHAR(255) NOT NULL,
    full_name    VARCHAR(100),
    email        VARCHAR(100) NOT NULL UNIQUE,
    phone        VARCHAR(20),
    role         VARCHAR(50) NOT NULL DEFAULT 'CUSTOMER',
    status       VARCHAR(20) DEFAULT 'ACTIVE',
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categories (
    category_id  INT PRIMARY KEY AUTO_INCREMENT,
    name         VARCHAR(100) NOT NULL UNIQUE,
    description  TEXT
);

CREATE TABLE products (
    product_id       INT PRIMARY KEY AUTO_INCREMENT,
    seller_id        INT NOT NULL,
    category_id      INT,
    name             VARCHAR(255) NOT NULL,
    description      TEXT,
    starting_price   DECIMAL(15,2) NOT NULL,
    condition_status VARCHAR(50) DEFAULT 'GOOD',
    status           VARCHAR(50) DEFAULT 'PENDING',
    created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (seller_id) REFERENCES users(user_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE product_images (
    image_id    INT PRIMARY KEY AUTO_INCREMENT,
    product_id  INT NOT NULL,
    image_url   VARCHAR(500),
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

CREATE TABLE auctions (
    auction_id      INT PRIMARY KEY AUTO_INCREMENT,
    product_id      INT NOT NULL UNIQUE,
    start_time      DATETIME NOT NULL,
    end_time        DATETIME NOT NULL,
    current_price   DECIMAL(15,2) DEFAULT 0,
    deposit_percent DECIMAL(5,2) DEFAULT 10,
    deposit_amount  DECIMAL(15,2) DEFAULT 0,
    winner_id       INT,
    status          VARCHAR(50) DEFAULT 'UPCOMING',
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (winner_id) REFERENCES users(user_id)
);

CREATE TABLE bids (
    bid_id      INT PRIMARY KEY AUTO_INCREMENT,
    auction_id  INT NOT NULL,
    bidder_id   INT NOT NULL,
    bid_amount  DECIMAL(15,2) NOT NULL,
    bid_time    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (auction_id) REFERENCES auctions(auction_id),
    FOREIGN KEY (bidder_id) REFERENCES users(user_id)
);

CREATE TABLE wallets (
    wallet_id       INT PRIMARY KEY AUTO_INCREMENT,
    user_id         INT NOT NULL UNIQUE,
    balance         DECIMAL(15,2) DEFAULT 0,
    locked_balance  DECIMAL(15,2) DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE auction_deposits (
    deposit_id      INT PRIMARY KEY AUTO_INCREMENT,
    auction_id      INT NOT NULL,
    user_id         INT NOT NULL,
    deposit_amount  DECIMAL(15,2) NOT NULL,
    status          VARCHAR(50) DEFAULT 'LOCKED',
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_auction_user (auction_id, user_id),
    FOREIGN KEY (auction_id) REFERENCES auctions(auction_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE payments (
    payment_id      INT PRIMARY KEY AUTO_INCREMENT,
    auction_id      INT NOT NULL UNIQUE,
    buyer_id        INT NOT NULL,
    seller_id       INT NOT NULL,
    amount          DECIMAL(15,2) NOT NULL,
    deposit_used    DECIMAL(15,2) DEFAULT 0,
    platform_fee    DECIMAL(15,2) DEFAULT 0,
    seller_receive  DECIMAL(15,2) DEFAULT 0,
    payment_date    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status          VARCHAR(50) DEFAULT 'PENDING',
    FOREIGN KEY (auction_id) REFERENCES auctions(auction_id),
    FOREIGN KEY (buyer_id) REFERENCES users(user_id),
    FOREIGN KEY (seller_id) REFERENCES users(user_id)
);

CREATE TABLE wallet_transactions (
    transaction_id    INT PRIMARY KEY AUTO_INCREMENT,
    wallet_id         INT NOT NULL,
    amount            DECIMAL(15,2) NOT NULL,
    transaction_type  VARCHAR(50) NOT NULL,
    reference_id      INT,
    description       VARCHAR(500),
    created_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (wallet_id) REFERENCES wallets(wallet_id)
);

-- =============================================================================
-- SAMPLE DATA — dữ liệu test đầy đủ (VND)
-- Tài khoản: mật khẩu tất cả = 123456
--   admin, manager, staff1 | seller1, seller2 | buyer1, buyer2
-- =============================================================================

INSERT INTO users (username, password, full_name, email, phone, role) VALUES
('admin',   '123456', 'System Admin',    'admin@auction.com',   '0901111111', 'ADMIN'),
('manager', '123456', 'Auction Manager', 'manager@auction.com', '0902222222', 'AUCTION_MANAGER'),
('staff1',  '123456', 'Staff User',      'staff@auction.com',   '0903333333', 'STAFF'),
('seller1', '123456', 'Tran Seller',     'seller1@auction.com', '0904444444', 'CUSTOMER'),
('seller2', '123456', 'Le Thi Seller',   'seller2@auction.com', '0906666666', 'CUSTOMER'),
('buyer1',  '123456', 'Nguyen Buyer',    'buyer1@auction.com',  '0905555555', 'CUSTOMER'),
('buyer2',  '123456', 'Tran Buyer Two',  'buyer2@auction.com',  '0907777777', 'CUSTOMER');

-- Ví sau giao dịch mẫu (balance khả dụng | locked cọc)
-- user_id: 1=admin 2=manager 3=staff 4=seller1 5=seller2 6=buyer1 7=buyer2
INSERT INTO wallets (user_id, balance, locked_balance) VALUES
(1, 4250000,    0),
(2, 0,          0),
(3, 0,          0),
(4, 130750000,  0),
(5, 30000000,   0),
(6, 94500000,   28500000),
(7, 120200000,  29800000);

INSERT INTO categories (name, description) VALUES
('Electronics',  'Điện thoại, laptop, thiết bị số'),
('Fashion',      'Quần áo, giày dép, phụ kiện'),
('Vehicles',     'Xe máy, xe đạp'),
('Collectibles', 'Đồng hồ, tranh, đồ sưu tầm');

INSERT INTO products (seller_id, category_id, name, description, starting_price, condition_status, status) VALUES
(4, 4, 'Rolex Submariner Date',      'Đồng hồ Rolex Submariner bản vintage, fullbox',           250000000, 'EXCELLENT', 'AUCTIONING'),
(4, 1, 'MacBook Pro M3 14"',         'Chip M3, 16GB RAM, 512GB SSD, còn bảo hành',              35000000,  'LIKE_NEW',  'AUCTIONING'),
(4, 3, 'Yamaha R15 V4',              'Xe thể thao 2022, odo 8.000 km',                          45000000,  'GOOD',      'APPROVED'),
(4, 1, 'iPhone 15 Pro Max 256GB',    'Màu Titan tự nhiên, pin 98%',                             22000000,  'LIKE_NEW',  'AUCTIONING'),
(5, 2, 'Nike Air Jordan 1 Retro',    'Size 42, deadstock, hàng chính hãng',                     8500000,   'NEW',       'PENDING'),
(5, 1, 'Samsung Smart TV 55 QLED',   'Model 2023, còn bảo hành 18 tháng',                       12000000,  'LIKE_NEW',  'PENDING'),
(4, 3, 'Honda Wave Alpha 110',       'Xe số 2021, biển SG, giấy tờ đầy đủ',                    48000000,  'GOOD',      'AUCTIONING'),
(4, 1, 'Canon EOS R6 Mark II',       'Body only, shutter 5.000, kèm 2 pin',                     80000000,  'EXCELLENT', 'SOLD'),
(5, 2, 'Túi xách Louis Vuitton',     'Hàng fake — từ chối duyệt',                               5000000,   'FAIR',      'REJECTED');

INSERT INTO product_images (product_id, image_url) VALUES
(1, 'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?w=800'),
(2, 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=800'),
(3, 'https://images.unsplash.com/photo-1558981403-c5f9899a28bc?w=800'),
(4, 'https://images.unsplash.com/photo-1592286923080-5b8f0c5649c5?w=800'),
(5, 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800'),
(6, 'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?w=800'),
(7, 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800'),
(8, 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=800'),
(9, 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=800');

-- Phiên đấu giá (1 sản phẩm = 1 phiên)
INSERT INTO auctions (product_id, start_time, end_time, current_price, deposit_percent, deposit_amount, winner_id, status) VALUES
(1, NOW() - INTERVAL 2 DAY,  NOW() + INTERVAL 5 DAY,  275000000, 10, 25000000, NULL,    'ACTIVE'),
(2, NOW() - INTERVAL 1 DAY,  NOW() + INTERVAL 3 DAY,  38500000,  10, 3500000,  NULL,    'ACTIVE'),
(4, NOW() + INTERVAL 1 DAY,  NOW() + INTERVAL 8 DAY,  22000000,  10, 2200000,  NULL,    'UPCOMING'),
(7, NOW() - INTERVAL 10 DAY, NOW() - INTERVAL 3 DAY,  52000000,  10, 4800000,  7,       'ENDED'),
(8, NOW() - INTERVAL 14 DAY, NOW() - INTERVAL 7 DAY,  85000000,  10, 8000000,  6,       'ENDED');

INSERT INTO bids (auction_id, bidder_id, bid_amount, bid_time) VALUES
-- Rolex: buyer2 (7) rồi buyer1 (6) vượt giá
(1, 7, 260000000, NOW() - INTERVAL 36 HOUR),
(1, 6, 270000000, NOW() - INTERVAL 30 HOUR),
(1, 6, 275000000, NOW() - INTERVAL 12 HOUR),
-- MacBook: buyer1 (6) dẫn đầu
(2, 6, 37000000,  NOW() - INTERVAL 20 HOUR),
(2, 6, 38500000,  NOW() - INTERVAL 8 HOUR),
-- Honda đã kết thúc — buyer2 (7) thắng
(4, 6, 50000000,  NOW() - INTERVAL 5 DAY),
(4, 7, 51000000,  NOW() - INTERVAL 4 DAY),
(4, 7, 52000000,  NOW() - INTERVAL 3 DAY),
-- Canon đã thanh toán — buyer1 (6) thắng
(5, 6, 82000000,  NOW() - INTERVAL 8 DAY),
(5, 6, 85000000,  NOW() - INTERVAL 7 DAY);

INSERT INTO auction_deposits (auction_id, user_id, deposit_amount, status) VALUES
(1, 6, 25000000, 'LOCKED'),   -- buyer1 cọc Rolex
(1, 7, 25000000, 'LOCKED'),   -- buyer2 cọc Rolex
(2, 6, 3500000,  'LOCKED'),   -- buyer1 cọc MacBook
(4, 7, 4800000,  'LOCKED'),   -- buyer2 cọc Honda — chờ thanh toán
(5, 6, 8000000,  'USED_FOR_PAYMENT'); -- buyer1 đã dùng cọc Canon

INSERT INTO payments (auction_id, buyer_id, seller_id, amount, deposit_used, platform_fee, seller_receive, payment_date, status) VALUES
(4, 7, 4, 52000000, 4800000, 2600000, 49400000, NOW() - INTERVAL 3 DAY, 'PENDING'),
(5, 6, 4, 85000000, 8000000, 4250000, 80750000, NOW() - INTERVAL 6 DAY, 'PAID');

INSERT INTO wallet_transactions (wallet_id, amount, transaction_type, reference_id, description, created_at) VALUES
-- buyer1 (wallet 6)
(6, 200000000, 'TOP_UP',        NULL, 'Nạp tiền ban đầu',                     NOW() - INTERVAL 20 DAY),
(6, -8000000,  'DEPOSIT_LOCK',  5,    'Khóa cọc phiên đấu giá #5 (Canon)',   NOW() - INTERVAL 9 DAY),
(6, -77000000, 'PAYMENT',       5,    'Thanh toán phiên đấu giá #5',        NOW() - INTERVAL 6 DAY),
(6, -25000000, 'DEPOSIT_LOCK',  1,    'Khóa cọc phiên đấu giá #1 (Rolex)',  NOW() - INTERVAL 2 DAY),
(6, -3500000,  'DEPOSIT_LOCK',  2,    'Khóa cọc phiên đấu giá #2 (MacBook)', NOW() - INTERVAL 1 DAY),
-- buyer2 (wallet 7)
(7, 150000000, 'TOP_UP',        NULL, 'Nạp tiền ban đầu',                     NOW() - INTERVAL 15 DAY),
(7, -25000000, 'DEPOSIT_LOCK',  1,    'Khóa cọc phiên đấu giá #1 (Rolex)',   NOW() - INTERVAL 36 HOUR),
(7, -4800000,  'DEPOSIT_LOCK',  4,    'Khóa cọc phiên đấu giá #4 (Honda)',    NOW() - INTERVAL 5 DAY),
-- seller1 (wallet 4)
(4, 50000000,  'TOP_UP',        NULL, 'Nạp tiền ban đầu',                     NOW() - INTERVAL 25 DAY),
(4, 80750000,  'SALE_INCOME',   5,    'Thu nhập bán Canon #5',               NOW() - INTERVAL 6 DAY),
-- admin (wallet 1)
(1, 4250000,   'PLATFORM_FEE',  5,    'Phí sàn phiên đấu giá #5',           NOW() - INTERVAL 6 DAY);
