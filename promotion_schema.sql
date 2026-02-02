-- 促销活动表
CREATE TABLE IF NOT EXISTS promotion (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    discount_type VARCHAR(20),
    discount_value DOUBLE,
    gift_description VARCHAR(500),
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_status (status),
    INDEX idx_time (start_time, end_time)
);

-- 车辆-促销关联表
CREATE TABLE IF NOT EXISTS car_promotion (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    car_id BIGINT NOT NULL,
    promotion_id BIGINT NOT NULL,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_car_promotion (car_id, promotion_id),
    FOREIGN KEY (car_id) REFERENCES car(id) ON DELETE CASCADE,
    FOREIGN KEY (promotion_id) REFERENCES promotion(id) ON DELETE CASCADE
);

-- 插入测试数据
INSERT INTO promotion (title, description, discount_type, discount_value, start_time, end_time) VALUES
('新春特惠', '春节购车享优惠', 'percentage', 0.95, '2024-01-01 00:00:00', '2024-02-28 23:59:59'),
('限量折扣', '限时限量特价', 'fixed', 10000.00, '2024-02-01 00:00:00', '2024-03-31 23:59:59'),
('购车送充电桩', '购车即送家用充电桩', 'gift', NULL, '2024-01-15 00:00:00', '2024-06-30 23:59:59');

-- 关联特斯拉车辆和促销
INSERT INTO car_promotion (car_id, promotion_id) VALUES
(1, 1), (1, 2),  -- Model 3关联两个促销
(2, 1);          -- Model Y关联新春特惠

SELECT '促销活动表:' AS '';
SELECT * FROM promotion;

SELECT '车辆-促销关联表:' AS '';
SELECT * FROM car_promotion;
