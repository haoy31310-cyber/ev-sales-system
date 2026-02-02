-- 车辆表
CREATE TABLE IF NOT EXISTS car (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    brand VARCHAR(50),
    model VARCHAR(50),
    range_km INT,
    battery_type VARCHAR(50),
    price DOUBLE,
    stock INT,
    status INT DEFAULT 1,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 促销活动表
CREATE TABLE IF NOT EXISTS promotion (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200),
    description TEXT,
    discount_type VARCHAR(20),
    discount_value DOUBLE,
    start_time DATETIME,
    end_time DATETIME,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 车辆-促销关联表
CREATE TABLE IF NOT EXISTS car_promotion (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    car_id BIGINT NOT NULL,
    promotion_id BIGINT NOT NULL,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_car_promotion (car_id, promotion_id)
);

-- 试驾预约表
CREATE TABLE IF NOT EXISTS test_drive (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    car_id BIGINT NOT NULL,
    store VARCHAR(100),
    drive_time DATETIME,
    status VARCHAR(20) DEFAULT 'PENDING',
    notes TEXT,
    apply_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    review_time DATETIME,
    review_notes TEXT
);
