-- Script tạo CSDL cho hệ thống đặt tour du lịch
-- Đã chuẩn hóa với khóa AUTO_INCREMENT, timestamp, enum trạng thái

CREATE DATABASE IF NOT EXISTS QuanLyDatTour CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE QuanLyDatTour;

-- 1. Người dùng (Gộp thông tin chung, tách role)
CREATE TABLE NguoiDung (
    id INT AUTO_INCREMENT PRIMARY KEY,
    manguoidung VARCHAR(50) UNIQUE,
    tendangnhap VARCHAR(100) NOT NULL UNIQUE,
    matkhau VARCHAR(255) NOT NULL,
    hotennguoidung VARCHAR(100),
    email VARCHAR(150) UNIQUE,
    sdt VARCHAR(20),
    role ENUM('ADMIN','USER') NOT NULL DEFAULT 'USER',
    status ENUM('ACTIVE','LOCKED') NOT NULL DEFAULT 'ACTIVE',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_username (tendangnhap),
    INDEX idx_role_status (role, status)
);

-- 2. Khách hàng (thông tin bổ sung, 1-1 với NguoiDung role USER)
CREATE TABLE KhachHang (
    id INT AUTO_INCREMENT PRIMARY KEY,
    makhachhang VARCHAR(50) UNIQUE,
    nguoidung_id INT NOT NULL UNIQUE,
    diachi VARCHAR(255),
    attribute1 VARCHAR(255),
    FOREIGN KEY (nguoidung_id) REFERENCES NguoiDung(id) ON DELETE CASCADE
);

-- 3. Tour
CREATE TABLE Tour (
    id INT AUTO_INCREMENT PRIMARY KEY,
    matour VARCHAR(50) UNIQUE,
    tentour VARCHAR(255) NOT NULL,
    diadiem VARCHAR(255),
    thoiluong VARCHAR(50),
    gia DECIMAL(15,2) NOT NULL,
    mota TEXT,
    hinhanh VARCHAR(255),
    ngaykhoihanh DATE,
    phuongtienchinh VARCHAR(100),
    status ENUM('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_tour_status (status),
    INDEX idx_tour_diadiem (diadiem),
    INDEX idx_tour_created (created_at DESC)
);

-- 4. Điểm tham quan (n-n với Tour qua bảng liên kết)
CREATE TABLE DiemThamQuan (
    id INT AUTO_INCREMENT PRIMARY KEY,
    madiadiem VARCHAR(50) UNIQUE,
    tendiadiem VARCHAR(255),
    mota TEXT
);

CREATE TABLE Tour_DiemThamQuan (
    tour_id INT NOT NULL,
    diadiem_id INT NOT NULL,
    PRIMARY KEY (tour_id, diadiem_id),
    FOREIGN KEY (tour_id) REFERENCES Tour(id) ON DELETE CASCADE,
    FOREIGN KEY (diadiem_id) REFERENCES DiemThamQuan(id) ON DELETE CASCADE
);

-- 5. Khách sạn (có thể dùng chung giữa nhiều tour)
CREATE TABLE KhachSan (
    id INT AUTO_INCREMENT PRIMARY KEY,
    makhachsan VARCHAR(50) UNIQUE,
    tenkhachsan VARCHAR(255),
    gia DECIMAL(15,2),
    diachi VARCHAR(255),
    chatluong VARCHAR(50),
    hinhanh VARCHAR(500),
    trangthai VARCHAR(20) DEFAULT 'CON_PHONG',
    ngayden DATE
);

CREATE TABLE Tour_KhachSan (
    tour_id INT NOT NULL,
    khachsan_id INT NOT NULL,
    PRIMARY KEY (tour_id, khachsan_id),
    FOREIGN KEY (tour_id) REFERENCES Tour(id) ON DELETE CASCADE,
    FOREIGN KEY (khachsan_id) REFERENCES KhachSan(id) ON DELETE CASCADE
);

-- 6. Phương tiện (có thể dùng chung giữa nhiều tour)
CREATE TABLE PhuongTien (
    id INT AUTO_INCREMENT PRIMARY KEY,
    maphuongtien VARCHAR(50) UNIQUE,
    tenphuongtien VARCHAR(255),
    sochongoi INT
);

CREATE TABLE Tour_PhuongTien (
    tour_id INT NOT NULL,
    phuongtien_id INT NOT NULL,
    PRIMARY KEY (tour_id, phuongtien_id),
    FOREIGN KEY (tour_id) REFERENCES Tour(id) ON DELETE CASCADE,
    FOREIGN KEY (phuongtien_id) REFERENCES PhuongTien(id) ON DELETE CASCADE
);

-- 7. Đặt tour (Booking)
CREATE TABLE DatTour (
    id INT AUTO_INCREMENT PRIMARY KEY,
    madattour VARCHAR(50) UNIQUE,
    khachhang_id INT NOT NULL,
    tour_id INT NOT NULL,
    so_luong_nguoi INT NOT NULL DEFAULT 1,
    so_phong INT NOT NULL DEFAULT 1,
    tongtien DECIMAL(15,2),
    ngay_khoihanh DATETIME,
    ghichu TEXT,
    pttt VARCHAR(50), -- phương thức thanh toán (COD, Bank, Card...)
    tinhtrang ENUM('PENDING','CONFIRMED','CANCELLED') DEFAULT 'PENDING',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (khachhang_id) REFERENCES KhachHang(id) ON DELETE CASCADE,
    FOREIGN KEY (tour_id) REFERENCES Tour(id) ON DELETE CASCADE,
    INDEX idx_dattour_khachhang (khachhang_id),
    INDEX idx_dattour_tour (tour_id),
    INDEX idx_dattour_tinhtrang (tinhtrang),
    INDEX idx_dattour_created (created_at DESC)
);

-- 8. Chi tiết đặt tour (snapshot thông tin tại thời điểm đặt)
CREATE TABLE ChiTietDatTour (
    id INT AUTO_INCREMENT PRIMARY KEY,
    dattour_id INT NOT NULL,
    tour_id INT NOT NULL,
    tentour VARCHAR(255),
    tenkhachhang VARCHAR(255),
    ngaykhoihanh DATE,
    giatour DECIMAL(15,2),
    soluong INT DEFAULT 1,
    thanhtien DECIMAL(15,2),
    FOREIGN KEY (dattour_id) REFERENCES DatTour(id) ON DELETE CASCADE,
    FOREIGN KEY (tour_id) REFERENCES Tour(id),
    INDEX idx_chitiet_dattour (dattour_id)
);

-- 9. Đánh giá (Review gắn với tour và khách hàng)
CREATE TABLE DanhGia (
    id INT AUTO_INCREMENT PRIMARY KEY,
    madanhgia VARCHAR(50) UNIQUE,
    khachhang_id INT NOT NULL,
    tour_id INT NOT NULL,
    noidung TEXT,
    rating INT DEFAULT 5,
    trangthai VARCHAR(20) DEFAULT 'HIEN_THI',
    thoigian DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (khachhang_id) REFERENCES KhachHang(id) ON DELETE CASCADE,
    FOREIGN KEY (tour_id) REFERENCES Tour(id) ON DELETE CASCADE,
    INDEX idx_danhgia_tour (tour_id),
    INDEX idx_danhgia_khachhang (khachhang_id),
    INDEX idx_danhgia_trangthai (trangthai)
);

