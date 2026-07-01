DROP DATABASE IF EXISTS auction_system_local;

CREATE DATABASE auction_system_local
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

USE auction_system_local;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS wallettransactions;
DROP TABLE IF EXISTS auctiondeposits;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS bids;
DROP TABLE IF EXISTS notifications;
DROP TABLE IF EXISTS auctionsessions;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS wallets;
DROP TABLE IF EXISTS userroles;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS roles;

SET FOREIGN_KEY_CHECKS = 1;

-- =========================
-- ROLES
-- =========================
CREATE TABLE roles (
  RoleID INT AUTO_INCREMENT PRIMARY KEY,
  RoleName VARCHAR(50) NOT NULL UNIQUE
);

-- =========================
-- USERS
-- =========================
CREATE TABLE users (
  UserID INT AUTO_INCREMENT PRIMARY KEY,
  Username VARCHAR(50) NOT NULL UNIQUE,
  Password VARCHAR(255) NOT NULL,
  FullName VARCHAR(100) NOT NULL,
  Email VARCHAR(100) NOT NULL UNIQUE,
  Phone VARCHAR(20),
  Address VARCHAR(255),
  Status ENUM('Active','Inactive','Locked') DEFAULT 'Active',
  CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- USER ROLES
-- =========================
CREATE TABLE userroles (
  UserID INT NOT NULL,
  RoleID INT NOT NULL,
  PRIMARY KEY (UserID, RoleID),
  FOREIGN KEY (UserID) REFERENCES users(UserID),
  FOREIGN KEY (RoleID) REFERENCES roles(RoleID)
);

-- =========================
-- CATEGORIES
-- =========================
CREATE TABLE categories (
  CategoryID INT AUTO_INCREMENT PRIMARY KEY,
  CategoryName VARCHAR(100) NOT NULL UNIQUE,
  Description TEXT
);

-- =========================
-- WALLETS
-- =========================
CREATE TABLE wallets (
  WalletID INT AUTO_INCREMENT PRIMARY KEY,
  UserID INT NOT NULL UNIQUE,
  Balance DECIMAL(15,2) DEFAULT 0,
  CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (UserID) REFERENCES users(UserID)
);

-- =========================
-- PRODUCTS
-- =========================
CREATE TABLE products (
  ProductID INT AUTO_INCREMENT PRIMARY KEY,
  ProductName VARCHAR(150) NOT NULL,
  Description TEXT,
  CategoryID INT NOT NULL,
  OwnerID INT NOT NULL,
  StartingPrice DECIMAL(15,2) NOT NULL,
  ImageURL VARCHAR(255),
  Status ENUM('Pending','Approved','Rejected','Sold','Auctioning') DEFAULT 'Pending',
  CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (CategoryID) REFERENCES categories(CategoryID),
  FOREIGN KEY (OwnerID) REFERENCES users(UserID)
);

-- =========================
-- AUCTION SESSIONS
-- =========================
CREATE TABLE auctionsessions (
  AuctionID INT AUTO_INCREMENT PRIMARY KEY,
  ProductID INT NOT NULL,
  StartTime DATETIME NOT NULL,
  EndTime DATETIME NOT NULL,
  CurrentPrice DECIMAL(15,2) NOT NULL,
  WinnerID INT NULL,
  Status ENUM('Upcoming','Open','Closed','Cancelled') DEFAULT 'Upcoming',
  CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (ProductID) REFERENCES products(ProductID),
  FOREIGN KEY (WinnerID) REFERENCES users(UserID)
);

-- =========================
-- BIDS
-- =========================
CREATE TABLE bids (
  BidID INT AUTO_INCREMENT PRIMARY KEY,
  AuctionID INT NOT NULL,
  UserID INT NOT NULL,
  BidAmount DECIMAL(15,2) NOT NULL,
  BidTime DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (AuctionID) REFERENCES auctionsessions(AuctionID),
  FOREIGN KEY (UserID) REFERENCES users(UserID)
);

-- =========================
-- PAYMENTS
-- =========================
CREATE TABLE payments (
  PaymentID INT AUTO_INCREMENT PRIMARY KEY,
  AuctionID INT NOT NULL,
  BuyerID INT NOT NULL,
  Amount DECIMAL(15,2) NOT NULL,
  DepositAmount DECIMAL(15,2) NOT NULL DEFAULT 0,
  TotalAmount DECIMAL(15,2) DEFAULT NULL,
  PaymentMethod ENUM('Wallet','Banking','Cash') DEFAULT 'Wallet',
  Status ENUM('Pending','Paid','Failed','Refunded') DEFAULT 'Pending',
  PaymentDate DATETIME DEFAULT CURRENT_TIMESTAMP,
  DueDate DATETIME DEFAULT NULL,
  SellerAmount DECIMAL(15,2) DEFAULT NULL,
  CommissionAmount DECIMAL(15,2) DEFAULT NULL,
  FundsReleased TINYINT(1) NOT NULL DEFAULT 0,
  FOREIGN KEY (AuctionID) REFERENCES auctionsessions(AuctionID),
  FOREIGN KEY (BuyerID) REFERENCES users(UserID)
);

-- =========================
-- AUCTION DEPOSITS
-- =========================
CREATE TABLE auctiondeposits (
  DepositID INT AUTO_INCREMENT PRIMARY KEY,
  AuctionID INT NOT NULL,
  UserID INT NOT NULL,
  Amount DECIMAL(15,2) NOT NULL,
  Status ENUM('Held','Refunded','Applied','Forfeited') DEFAULT 'Held',
  CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uk_auction_user (AuctionID, UserID),
  FOREIGN KEY (AuctionID) REFERENCES auctionsessions(AuctionID),
  FOREIGN KEY (UserID) REFERENCES users(UserID)
);

-- =========================
-- WALLET TRANSACTIONS
-- =========================
CREATE TABLE wallettransactions (
  TransactionID INT AUTO_INCREMENT PRIMARY KEY,
  WalletID INT NOT NULL,
  Amount DECIMAL(15,2) NOT NULL,
  TransactionType ENUM('Deposit','Withdraw','Payment','Refund','Sale','Commission') NOT NULL,
  TransactionDate DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (WalletID) REFERENCES wallets(WalletID)
);

-- =========================
-- NOTIFICATIONS
-- =========================
CREATE TABLE notifications (
  NotificationID INT AUTO_INCREMENT PRIMARY KEY,
  UserID INT NOT NULL,
  Content TEXT NOT NULL,
  Status ENUM('Unread','Read') DEFAULT 'Unread',
  CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (UserID) REFERENCES users(UserID)
);

-- =========================
-- INSERT DATA
-- =========================

INSERT INTO roles (RoleName) VALUES
('Admin'),
('Manager'),
('Staff'),
('Customer');

INSERT INTO users (Username, Password, FullName, Email, Phone, Address, Status) VALUES
('admin', '123456', 'Quản trị viên', 'admin@gmail.com', '0900000001', 'TP.HCM', 'Active'),
('manager', '123456', 'Quản lý hệ thống', 'manager@gmail.com', '0900000002', 'TP.HCM', 'Active'),
('staff', '123456', 'Nhân viên đấu giá', 'staff@gmail.com', '0900000003', 'TP.HCM', 'Active'),
('customer1', '123456', 'Nguyễn Văn An', 'an@gmail.com', '0900000004', 'Quận 1', 'Active'),
('customer2', '123456', 'Trần Thị Bình', 'binh@gmail.com', '0900000005', 'Quận 6', 'Active'),
('customer3', '123456', 'Lê Minh Cường', 'cuong@gmail.com', '0900000006', 'Quận 10', 'Active');

INSERT INTO userroles (UserID, RoleID) VALUES
(1,1),
(2,2),
(3,3),
(4,4),
(5,4),
(6,4);

INSERT INTO categories (CategoryName, Description) VALUES
('Đồng hồ', 'Các loại đồng hồ cao cấp'),
('Điện thoại', 'Điện thoại cũ và mới'),
('Laptop', 'Máy tính xách tay'),
('Trang sức', 'Vàng bạc đá quý'),
('Đồ cổ', 'Sản phẩm sưu tầm cổ');

INSERT INTO wallets (UserID, Balance) VALUES
(1, 0),
(2, 0),
(3, 0),
(4, 50000000),
(5, 45000000),
(6, 30000000);

INSERT INTO products
(ProductName, Description, CategoryID, OwnerID, StartingPrice, ImageURL, Status) VALUES
('Rolex Datejust', 'Đồng hồ Rolex chính hãng', 1, 4, 50000000, 'rolex.jpg', 'Auctioning'),
('iPhone 15 Pro Max', 'Máy đẹp, còn bảo hành', 2, 5, 18000000, 'iphone.jpg', 'Auctioning'),
('MacBook Air M2', 'Laptop Apple M2 16GB RAM', 3, 6, 20000000, 'macbook.jpg', 'Auctioning'),
('Nhẫn vàng 18K', 'Nhẫn vàng nữ 18K', 4, 4, 7000000, 'ring.jpg', 'Auctioning'),
('Bình gốm cổ', 'Bình gốm sưu tầm', 5, 5, 12000000, 'gom.jpg', 'Auctioning');

INSERT INTO auctionsessions
(ProductID, StartTime, EndTime, CurrentPrice, WinnerID, Status) VALUES
(1, '2026-07-10 08:00:00', '2026-07-15 20:00:00', 56000000, NULL, 'Open'),
(2, '2026-07-10 09:00:00', '2026-07-14 20:00:00', 21000000, NULL, 'Open'),
(3, '2026-07-11 08:00:00', '2026-07-16 20:00:00', 23000000, NULL, 'Open'),
(4, '2026-07-10 10:00:00', '2026-07-13 20:00:00', 9000000, NULL, 'Open'),
(5, '2026-07-11 10:00:00', '2026-07-17 20:00:00', 15000000, NULL, 'Open');

INSERT INTO bids (AuctionID, UserID, BidAmount) VALUES
(1, 5, 52000000),
(1, 6, 56000000),
(2, 4, 19000000),
(2, 6, 21000000),
(3, 4, 22000000),
(3, 5, 23000000),
(4, 5, 8000000),
(4, 6, 9000000),
(5, 4, 14000000),
(5, 6, 15000000);

INSERT INTO auctiondeposits (AuctionID, UserID, Amount, Status) VALUES
(1, 5, 5000000, 'Held'),
(1, 6, 5000000, 'Held'),
(2, 4, 1800000, 'Held'),
(2, 6, 1800000, 'Held'),
(3, 4, 2000000, 'Held'),
(3, 5, 2000000, 'Held');

INSERT INTO payments (AuctionID, BuyerID, Amount, DepositAmount, TotalAmount, Status) VALUES
(1, 6, 50400000, 5600000, 56000000, 'Pending'),
(2, 6, 19200000, 1800000, 21000000, 'Pending');

INSERT INTO wallettransactions (WalletID, Amount, TransactionType, TransactionDate) VALUES
(4, 50000000, 'Deposit', '2026-06-24 19:28:45'),
(5, 45000000, 'Deposit', '2026-06-24 19:28:45'),
(6, 30000000, 'Deposit', '2026-06-24 19:28:45');

INSERT INTO notifications (UserID, Content, Status) VALUES
(4, 'Sản phẩm Rolex Datejust đã được duyệt đấu giá', 'Unread'),
(5, 'Sản phẩm iPhone 15 Pro Max có lượt trả giá mới', 'Unread'),
(6, 'Bạn đang dẫn đầu phiên đấu giá MacBook Air M2', 'Unread');

-- =========================
-- UPGRADE (chỉ dùng file database.sql này — chạy an toàn trên DB đã tồn tại)
-- Thêm cột thanh toán, mở rộng loại giao dịch ví, dọn phí Commission khỏi ví cá nhân
-- =========================
SET @db_name = DATABASE();

SET @col_exists := (
  SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @db_name AND TABLE_NAME = 'payments' AND COLUMN_NAME = 'SellerAmount'
);
SET @sql := IF(@col_exists = 0,
  'ALTER TABLE payments ADD COLUMN SellerAmount DECIMAL(15,2) DEFAULT NULL AFTER DueDate',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists := (
  SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @db_name AND TABLE_NAME = 'payments' AND COLUMN_NAME = 'CommissionAmount'
);
SET @sql := IF(@col_exists = 0,
  'ALTER TABLE payments ADD COLUMN CommissionAmount DECIMAL(15,2) DEFAULT NULL AFTER SellerAmount',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists := (
  SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @db_name AND TABLE_NAME = 'payments' AND COLUMN_NAME = 'FundsReleased'
);
SET @sql := IF(@col_exists = 0,
  'ALTER TABLE payments ADD COLUMN FundsReleased TINYINT(1) NOT NULL DEFAULT 0 AFTER CommissionAmount',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

ALTER TABLE wallettransactions
  MODIFY TransactionType ENUM('Deposit','Withdraw','Payment','Refund','Sale','Commission') NOT NULL;

-- Xóa phí hệ thống đã ghi nhầm vào ví cá nhân; tính lại số dư ví
DELETE FROM wallettransactions WHERE TransactionType = 'Commission';

UPDATE wallets w
SET Balance = COALESCE((
  SELECT SUM(CASE
    WHEN wt.TransactionType IN ('Deposit', 'Refund', 'Sale') THEN wt.Amount
    WHEN wt.TransactionType IN ('Payment', 'Withdraw') THEN -wt.Amount
    ELSE 0
  END)
  FROM wallettransactions wt
  WHERE wt.WalletID = w.WalletID
), 0);
