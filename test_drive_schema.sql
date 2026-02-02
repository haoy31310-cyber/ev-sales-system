-- 试驾预约表
CREATE TABLE IF NOT EXISTS test_drive (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    car_id BIGINT NOT NULL,
    store VARCHAR(100) NOT NULL,
    drive_time DATETIME NOT NULL,
    status VARCHAR(20) DEFAULT 'PENDING',
    notes TEXT,
    apply_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    review_time DATETIME,
    review_notes TEXT,
    INDEX idx_user (user_id),
    INDEX idx_status (status),
    INDEX idx_time (drive_time),
    FOREIGN KEY (car_id) REFERENCES car(id) ON DELETE CASCADE
);

-- 插入测试数据（假设用户ID 1001-1005）
INSERT INTO test_drive (user_id, car_id, store, drive_time, status) VALUES
(1001, 1, '北京特斯拉体验中心', '2024-02-10 14:00:00', 'APPROVED'),
(1002, 2, '上海特斯拉中心', '2024-02-12 10:30:00', 'PENDING'),
(1003, 3, '深圳比亚迪4S店', '2024-02-15 15:00:00', 'APPROVED'),
(1004, 1, '广州特斯拉体验店', '2024-02-08 11:00:00', 'COMPLETED');

SELECT '试驾预约表:' AS '';
SELECT * FROM test_drive;
