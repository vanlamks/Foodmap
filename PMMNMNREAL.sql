CREATE DATABASE PMMNMN;
USE PMMNMN;
-- 1️⃣ Bảng Users (Người dùng)
CREATE TABLE users (
    user_number varchar(50) PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2️⃣ Bảng Roles (Phân quyền)
CREATE TABLE roles (
    role_number varchar(50)  PRIMARY KEY,
    role_name VARCHAR(50) UNIQUE NOT NULL
);

-- 3️⃣ Bảng User Roles (Liên kết người dùng với quyền)
CREATE TABLE user_roles (
    user_number varchar(50)  NOT NULL,
    role_number varchar(50)  NOT NULL,
    PRIMARY KEY (user_number, role_number),
    FOREIGN KEY (user_number) REFERENCES users(user_number) ON DELETE CASCADE,
    FOREIGN KEY (role_number) REFERENCES roles(role_number) ON DELETE CASCADE
);

-- 4️⃣ Bảng Restaurants (Nhà hàng)
CREATE TABLE restaurants (
    restaurant_number varchar(50)  PRIMARY KEY,
    restaurant_name VARCHAR(255) NOT NULL,
    address TEXT NOT NULL,
    phone VARCHAR(20),
    description TEXT,
    opening_hours VARCHAR(255),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 5️⃣ Bảng Menus (Thực đơn)
CREATE TABLE menus (
    menu_number varchar(50)  PRIMARY KEY,
    restaurant_number varchar(50)  NOT NULL,
    menu_name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    image_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (restaurant_number) REFERENCES restaurants(restaurant_number) ON DELETE CASCADE
);
-- 6️⃣ Bảng Reviews (Đánh giá nhà hàng)
CREATE TABLE reviews (
    review_number varchar(50)  PRIMARY KEY,
    user_number varchar(50)  NOT NULL,
    restaurant_number varchar(50)  NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_approved BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_number) REFERENCES users(user_number) ON DELETE CASCADE,
    FOREIGN KEY (restaurant_number) REFERENCES restaurants(restaurant_number) ON DELETE CASCADE
);

-- 7️⃣ Bảng Favorites (Nhà hàng yêu thích)
CREATE TABLE favorites (
    favorite_number varchar(50)  PRIMARY KEY,
    user_number varchar(50)  NOT NULL,
    restaurant_number varchar(50)  NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_number) REFERENCES users(user_number) ON DELETE CASCADE,
    FOREIGN KEY (restaurant_number) REFERENCES restaurants(restaurant_number) ON DELETE CASCADE
);

-- 8️⃣ Bảng Search History (Lịch sử tìm kiếm)
CREATE TABLE search_history (
    search_number varchar(50)  PRIMARY KEY,
    user_number varchar(50)  NOT NULL,
    search_query VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_number) REFERENCES users(user_number) ON DELETE CASCADE
);

-- 🟢 Thêm vai trò (Admin & Khách hàng)
INSERT INTO roles (role_number, role_name) VALUES
(1, 'admin'),
(2, 'customer');

-- 🟢 Thêm người dùng mẫu
INSERT INTO users (user_number, full_name, email, password_hash, created_at) VALUES
(101, 'Admin User', 'admin@example.com', 'hashed_password_admin', '2025-03-17 17:05:47'),
(102, 'John Doe', 'johndoe@gmail.com', 'hashed_password_123', '2025-03-17 17:05:47'),
(103, 'Alice Smith', 'alice@gmail.com', 'hashed_password_456', '2025-03-17 17:05:47'),
(1111, 'lam', 'vanlam@gmail.com', 'pbkdf2_sha256$870000$VefUjmgQHEmRvijrtkGDB$2OC0p+lN24GG7S1xIrKb1bwD479I53/p9QjzVNFQL8A=', '2025-03-22 08:09:50'),
(774, 'aaaa', 'hungn@gmail.com', 'sssssss', '2025-03-21 05:14:24');


-- 🟢 Gán quyền cho người dùng
INSERT INTO user_roles (user_number, role_number) VALUES
(101, 1), -- User 101 là Admin
(102, 2), -- User 102 là Khách hàng
(103, 2); -- User 103 là Khách hàng

-- 🟢 Thêm nhà hàng
INSERT INTO restaurants (restaurant_number, restaurant_name, address, phone, description, opening_hours, latitude, longitude) VALUES
(11, 'BEEF', 'vvv', '0227787778', 'dR', '6h', 19.5000, 19.6000),
(202, 'Sushi Heaven', '456 Ocean Drive, Los Angeles, CA', '0987654321', 'Premium sushi, fresh ingredients.', '11:00 AM - 10:00 PM', 34.0522, -118.2437),
(207, 'Beef Heaven', '45 Ocean Drive, Los Angeles, CA', '0557883641', 'Premium beef, fresh ingredients.', '08:00 AM - 10:00 PM', 30.0522, -18.2437),
(2081, 'Beef Heaven', '45 Ocean Drive, Los Angeles, CA', '0557883641', 'Premium beef, fresh ingredients.', '08:00 AM - 10:00 PM', 30.0522, -18.2437),
(441, 'Milk and Tea', 'vvv', '0223887778', 'ds', '6h', 14.5000, 17.6000);

-- 🟢 Thêm thực đơn
INSERT INTO menus (menu_number, restaurant_number, menu_name, description, price, image_url, created_at) VALUES
(302, 202, 'Salmon Sushi', 'Fresh salmon sushi', 9.99, 'https://example.com/salmon.jpg', '2025-03-17 17:05:47'),
(32, 202, 'Pho', 'Pho Viet', 3.99, 'https://i1-dulich.vnecdn.net/2020/03/04/7174177733-6c0af1a0b2-b-4778-1583317457.jpg?w=0&h=0&q=100&dpr=1&fit=crop&s=W5Ll2-T9398seyb0orXqFA', '2025-03-23 08:36:03');


-- 🟢 Thêm đánh giá
INSERT INTO reviews (review_number, user_number, restaurant_number, rating, comment, is_approved) VALUES
(401, 102, 207, 5, 'The pizza is amazing!', TRUE),
(402, 103, 202, 4, 'Fresh sushi but service was slow.', TRUE);

-- 🟢 Thêm nhà hàng yêu thích
INSERT INTO favorites (favorite_number, user_number, restaurant_number) VALUES
(501, 102, 207), 
(502, 103, 202);

-- 🟢 Thêm lịch sử tìm kiếm
INSERT INTO search_history (search_number, user_number, search_query) VALUES
(601, 102, 'Pizza'),
(602, 103, 'Best sushi in Los Angeles');


