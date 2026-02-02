-- 新能源汽车销售系统 - 车辆相关表
-- 由B同学（车辆管理模块）负责

-- 车辆信息表
CREATE TABLE IF NOT EXISTS car (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '车辆ID',
    name VARCHAR(100) NOT NULL COMMENT '车型名称',
    brand VARCHAR(50) NOT NULL COMMENT '品牌',
    model VARCHAR(50) COMMENT '型号',
    range_km INT NOT NULL COMMENT '续航里程(km)',
    battery_type VARCHAR(50) COMMENT '电池类型',
    price DECIMAL(10,2) NOT NULL COMMENT '指导价',
    stock INT DEFAULT 0 COMMENT '库存数量',
    launch_date DATE COMMENT '上市时间',
    fast_charge_minutes INT COMMENT '快充时间(分钟)',
    smart_driving_level VARCHAR(20) COMMENT '智能驾驶等级',
    description TEXT COMMENT '配置参数描述',
    status TINYINT DEFAULT 1 COMMENT '状态：0-下架，1-上架',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    INDEX idx_brand (brand),
    INDEX idx_price (price),
    INDEX idx_range (range_km),
    INDEX idx_status (status),
    INDEX idx_stock (stock)
) COMMENT='车辆信息表';

-- 车辆评价表
CREATE TABLE IF NOT EXISTS car_comment (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '评价ID',
    car_id BIGINT NOT NULL COMMENT '车辆ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    rating INT CHECK (rating BETWEEN 1 AND 5) COMMENT '评分1-5星',
    content TEXT COMMENT '评价内容',
    images JSON COMMENT '图片URL数组',
    comment_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '评价时间',
    
    FOREIGN KEY (car_id) REFERENCES car(id) ON DELETE CASCADE,
    INDEX idx_car_id (car_id),
    INDEX idx_user_id (user_id),
    INDEX idx_rating (rating)
) COMMENT='车辆评价表';

-- 插入测试数据
INSERT INTO car (name, brand, model, range_km, battery_type, price, stock, launch_date, fast_charge_minutes, smart_driving_level, description) VALUES
('Model 3', '特斯拉', '后轮驱动版', 556, '三元锂电池', 245900.00, 15, '2024-01-01', 30, 'L2', '后轮驱动，百公里加速6.1秒'),
('Model Y', '特斯拉', '长续航全轮驱动版', 688, '三元锂电池', 299900.00, 8, '2024-02-01', 25, 'L2+', '双电机全轮驱动，百公里加速5.0秒'),
('汉EV', '比亚迪', '冠军版 715KM', 715, '磷酸铁锂电池', 269800.00, 20, '2024-03-01', 30, 'L2', '刀片电池，超长续航'),
('唐DM-i', '比亚迪', '冠军版 112KM', 112, '磷酸铁锂电池', 219800.00, 12, '2024-02-15', 60, 'L2', '超级混动，亏电油耗5.5L'),
('理想L7', '理想', 'Pro版', 210, '三元锂电池', 339800.00, 6, '2024-01-20', 30, 'L2+', '增程式电动，综合续航1315km'),
('蔚来ET5', '蔚来', '75kWh', 560, '三元锂电池', 298000.00, 10, '2024-03-10', 20, 'L2+', '换电模式，四驱系统'),
('小鹏P7', '小鹏', '670N+', 670, '三元锂电池', 259900.00, 7, '2024-02-28', 30, 'L2+', 'NGP智能导航辅助驾驶'),
('极氪001', '极氪', 'WE版 100kWh', 741, '三元锂电池', 300000.00, 3, '2024-03-05', 30, 'L2+', '猎装轿跑，高性能');

-- 插入测试评价数据
INSERT INTO car_comment (car_id, user_id, rating, content) VALUES
(1, 1, 5, '加速非常快，操控性好，续航真实'),
(1, 2, 4, '内饰简洁，科技感强，就是价格有点高'),
(2, 3, 5, '空间大，适合家庭使用，智能驾驶好用'),
(3, 4, 5, '续航真实，充电速度快，性价比高'),
(4, 5, 4, '混动系统很省油，市区通勤神器');

-- 查看数据
SELECT '车辆数据:' AS '';
SELECT * FROM car;

SELECT '车辆评价数据:' AS '';
SELECT * FROM car_comment;

SELECT '库存不足车辆（≤5）:' AS '';
SELECT * FROM car WHERE stock <= 5 AND status = 1;

SELECT '品牌统计:' AS '';
SELECT brand, COUNT(*) as count, SUM(stock) as total_stock FROM car WHERE status = 1 GROUP BY brand;

SELECT '价格区间统计:' AS '';
SELECT 
    CASE 
        WHEN price < 200000 THEN '20万以下'
        WHEN price < 300000 THEN '20-30万'
        WHEN price < 400000 THEN '30-40万'
        ELSE '40万以上'
    END as price_range,
    COUNT(*) as count
FROM car WHERE status = 1
GROUP BY price_range
ORDER BY MIN(price);
