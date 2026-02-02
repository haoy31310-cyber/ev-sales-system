-- 插入车辆数据
INSERT INTO car (name, brand, model, range_km, battery_type, price, stock) VALUES
('特斯拉 Model 3', '特斯拉', '后驱版', 556, '三元锂电池', 245900.00, 10),
('特斯拉 Model Y', '特斯拉', '长续航版', 688, '三元锂电池', 299900.00, 5),
('比亚迪 汉EV', '比亚迪', '冠军版', 715, '磷酸铁锂电池', 269800.00, 15),
('理想 L9', '理想', 'Max版', 215, '三元锂电池', 459800.00, 3);

-- 插入促销数据
INSERT INTO promotion (title, description, discount_type, discount_value, start_time, end_time) VALUES
('新春特惠', '春节购车享优惠', 'percentage', 0.95, '2024-01-01 00:00:00', '2024-02-28 23:59:59'),
('限量折扣', '限时限量特价', 'fixed', 10000.00, '2024-02-01 00:00:00', '2024-03-31 23:59:59');

-- 插入关联数据
INSERT INTO car_promotion (car_id, promotion_id) VALUES (1, 1), (1, 2), (2, 1);

-- 插入试驾数据
INSERT INTO test_drive (user_id, car_id, store, drive_time, status) VALUES
(1001, 1, '北京特斯拉体验中心', '2024-02-10 14:00:00', 'APPROVED'),
(1002, 2, '上海特斯拉中心', '2024-02-12 10:30:00', 'PENDING'),
(1003, 3, '深圳比亚迪4S店', '2024-02-15 15:00:00', 'APPROVED');
