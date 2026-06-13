create DATABASE auction_management_system;
USE auction_management_system;
-- =====================================================
-- USERS
-- =====================================================
CREATE TABLE users (
user_id BIGINT AUTO_INCREMENT PRIMARY KEY,
username VARCHAR(50) NOT NULL UNIQUE,
password VARCHAR(255) NOT NULL,
full_name VARCHAR(100) NOT NULL,
email VARCHAR(100) NOT NULL UNIQUE,
phone VARCHAR(20),

role ENUM('ADMIN','STAFF','USER')
DEFAULT 'USER',

status ENUM('ACTIVE','INACTIVE','BANNED')
DEFAULT 'ACTIVE',

created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
ON UPDATE CURRENT_TIMESTAMP

);

-- =====================================================
-- CATEGORIES
-- =====================================================
CREATE TABLE categories (
category_id BIGINT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100) NOT NULL,
description TEXT
);

-- =====================================================
-- PRODUCTS
-- =====================================================
CREATE TABLE products (
product_id BIGINT AUTO_INCREMENT PRIMARY KEY,

seller_id BIGINT NOT NULL,
category_id BIGINT NOT NULL,

name VARCHAR(255) NOT NULL,
description TEXT,

starting_price DECIMAL(15,2) NOT NULL,

product_condition ENUM(
    'NEW',
    'LIKE_NEW',
    'USED',
    'DAMAGED'
) DEFAULT 'USED',

status ENUM(
    'PENDING',
    'APPROVED',
    'REJECTED',
    'AUCTIONING',
    'SOLD'
) DEFAULT 'PENDING',

created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
ON UPDATE CURRENT_TIMESTAMP,

CONSTRAINT fk_product_user
    FOREIGN KEY (seller_id)
    REFERENCES users(user_id),

CONSTRAINT fk_product_category
    FOREIGN KEY (category_id)
    REFERENCES categories(category_id)

);

-- =====================================================
-- PRODUCT IMAGES
-- =====================================================
CREATE TABLE product_images (
image_id BIGINT AUTO_INCREMENT PRIMARY KEY,

product_id BIGINT NOT NULL,

image_url VARCHAR(500) NOT NULL,

uploaded_at DATETIME DEFAULT CURRENT_TIMESTAMP,

CONSTRAINT fk_image_product
    FOREIGN KEY (product_id)
    REFERENCES products(product_id)
    ON DELETE CASCADE

);

-- =====================================================
-- AUCTIONS
-- =====================================================
CREATE TABLE auctions (
auction_id BIGINT AUTO_INCREMENT PRIMARY KEY,

product_id BIGINT NOT NULL UNIQUE,

start_time DATETIME NOT NULL,
end_time DATETIME NOT NULL,

current_price DECIMAL(15,2),

deposit_percent DECIMAL(5,2)
DEFAULT 10.00,

deposit_amount DECIMAL(15,2),

winner_id BIGINT NULL,

status ENUM(
    'UPCOMING',
    'ACTIVE',
    'ENDED',
    'CANCELLED'
) DEFAULT 'UPCOMING',

created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

CONSTRAINT fk_auction_product
    FOREIGN KEY (product_id)
    REFERENCES products(product_id),

CONSTRAINT fk_auction_winner
    FOREIGN KEY (winner_id)
    REFERENCES users(user_id)

);

-- =====================================================
-- BIDS
-- =====================================================
CREATE TABLE bids (
bid_id BIGINT AUTO_INCREMENT PRIMARY KEY,

auction_id BIGINT NOT NULL,
bidder_id BIGINT NOT NULL,

bid_amount DECIMAL(15,2) NOT NULL,

bid_time DATETIME DEFAULT CURRENT_TIMESTAMP,

CONSTRAINT fk_bid_auction
    FOREIGN KEY (auction_id)
    REFERENCES auctions(auction_id)
    ON DELETE CASCADE,

CONSTRAINT fk_bid_user
    FOREIGN KEY (bidder_id)
    REFERENCES users(user_id)

);

-- =====================================================
-- WALLETS
-- =====================================================
CREATE TABLE wallets (
wallet_id BIGINT AUTO_INCREMENT PRIMARY KEY,

user_id BIGINT NOT NULL UNIQUE,

balance DECIMAL(15,2)
DEFAULT 0.00,

locked_balance DECIMAL(15,2)
DEFAULT 0.00,

created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
ON UPDATE CURRENT_TIMESTAMP,

CONSTRAINT fk_wallet_user
    FOREIGN KEY (user_id)
    REFERENCES users(user_id)

);

-- =====================================================
-- AUCTION DEPOSITS
-- =====================================================
CREATE TABLE auction_deposits (
deposit_id BIGINT AUTO_INCREMENT PRIMARY KEY,

auction_id BIGINT NOT NULL,
user_id BIGINT NOT NULL,

deposit_amount DECIMAL(15,2) NOT NULL,

status ENUM(
    'LOCKED',
    'REFUNDED',
    'USED_FOR_PAYMENT',
    'FORFEITED'
) DEFAULT 'LOCKED',

created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

CONSTRAINT fk_deposit_auction
    FOREIGN KEY (auction_id)
    REFERENCES auctions(auction_id),

CONSTRAINT fk_deposit_user
    FOREIGN KEY (user_id)
    REFERENCES users(user_id)

);

-- =====================================================
-- PAYMENTS
-- =====================================================
CREATE TABLE payments (
payment_id BIGINT AUTO_INCREMENT PRIMARY KEY,

auction_id BIGINT NOT NULL UNIQUE,

buyer_id BIGINT NOT NULL,
seller_id BIGINT NOT NULL,

amount DECIMAL(15,2) NOT NULL,

deposit_used DECIMAL(15,2)
DEFAULT 0.00,

platform_fee DECIMAL(15,2)
DEFAULT 0.00,

seller_receive DECIMAL(15,2)
DEFAULT 0.00,

status ENUM(
    'PENDING',
    'PAID',
    'FAILED',
    'REFUNDED'
) DEFAULT 'PENDING',

payment_date DATETIME NULL,

CONSTRAINT fk_payment_auction
    FOREIGN KEY (auction_id)
    REFERENCES auctions(auction_id),

CONSTRAINT fk_payment_buyer
    FOREIGN KEY (buyer_id)
    REFERENCES users(user_id),

CONSTRAINT fk_payment_seller
    FOREIGN KEY (seller_id)
    REFERENCES users(user_id)

);

-- =====================================================
-- WALLET TRANSACTIONS
-- =====================================================
CREATE TABLE wallet_transactions (
transaction_id BIGINT AUTO_INCREMENT PRIMARY KEY,

wallet_id BIGINT NOT NULL,

amount DECIMAL(15,2) NOT NULL,

transaction_type ENUM(
    'DEPOSIT',
    'WITHDRAW',
    'AUCTION_DEPOSIT',
    'DEPOSIT_REFUND',
    'PAYMENT',
    'RECEIVE_MONEY',
    'PLATFORM_FEE'
) NOT NULL,

reference_id BIGINT NULL,

description VARCHAR(255),

created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

CONSTRAINT fk_transaction_wallet
    FOREIGN KEY (wallet_id)
    REFERENCES wallets(wallet_id)

);

-- =====================================================
-- NOTIFICATIONS
-- =====================================================
CREATE TABLE notifications (
notification_id BIGINT AUTO_INCREMENT PRIMARY KEY,

user_id BIGINT NOT NULL,

title VARCHAR(255) NOT NULL,

message TEXT NOT NULL,

is_read BOOLEAN DEFAULT FALSE,

created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

CONSTRAINT fk_notification_user
    FOREIGN KEY (user_id)
    REFERENCES users(user_id)

);
