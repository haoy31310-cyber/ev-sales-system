-- 创建数据库
CREATE DATABASE IF NOT EXISTS ev_sales DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ev_sales;

-- 车辆信息表
CREATE TABLE car (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL COMMENT '车型名称',
    brand VARCHAR(50) NOT NULL COMMENT '品牌',
    model VARCHAR(50) COMMENT '型号',
    range_km INT NOT NULL COMMENT '续航里程(km)',
    battery_type VARCHAR(50) COMMENT '电池类型',
    price DECIMAL(10,2) NOT NULL COMMENT '指导价',
    stock INT NOT NULL DEFAULT 0 COMMENT '库存数量',
    release_date DATE COMMENT '上市时间',
    fast_charge_time INT COMMENT '快充时间(分钟)',
    autonomous_level VARCHAR(20) COMMENT '智能驾驶等级',
    description TEXT COMMENT '车辆描述',
    image_url VARCHAR(500) COMMENT '图片地址',
    status TINYINT DEFAULT 1 COMMENT '状态(0:下架,1:在售)',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_brand (brand),
    INDEX idx_price (price),
    INDEX idx_range (range_km)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='车辆信息表';

-- 促销活动表
CREATE TABLE promotion (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL COMMENT '活动标题',
    description TEXT COMMENT '活动描述',
    type TINYINT NOT NULL COMMENT '活动类型(1:折扣,2:赠品,3:补贴)',
    discount_rate DECIMAL(5,2) COMMENT '折扣率',
    gift_desc VARCHAR(500) COMMENT '赠品描述',
    subsidy_amount DECIMAL(10,2) COMMENT '补贴金额',
    start_time DATETIME NOT NULL COMMENT '开始时间',
    end_time DATETIME NOT NULL COMMENT '结束时间',
    status TINYINT DEFAULT 1 COMMENT '状态(0:下架,1:进行中,2:已结束)',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_status (status),
    INDEX idx_time (start_time, end_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='促销活动表';

-- 车辆促销关联表
CREATE TABLE car_promotion (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    car_id BIGINT NOT NULL COMMENT '车辆ID',
    promotion_id BIGINT NOT NULL COMMENT '活动ID',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_car_promotion (car_id, promotion_id),
    FOREIGN KEY (car_id) REFERENCES car(id) ON DELETE CASCADE,
    FOREIGN KEY (promotion_id) REFERENCES promotion(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='车辆促销关联表';

-- 车辆评价表
CREATE TABLE car_comment (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    car_id BIGINT NOT NULL COMMENT '车辆ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    rating TINYINT NOT NULL COMMENT '评分(1-5)',
    content TEXT COMMENT '评价内容',
    images VARCHAR(1000) COMMENT '图片URL，多个用逗号分隔',
    order_id BIGINT COMMENT '关联订单ID',
    is_anonymous TINYINT DEFAULT 0 COMMENT '是否匿名(0:否,1:是)',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '评价时间',
    INDEX idx_car_id (car_id),
    INDEX idx_user_id (user_id),
    FOREIGN KEY (car_id) REFERENCES car(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='车辆评价表';

-- 试驾预约表
CREATE TABLE test_drive (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL COMMENT '用户ID',
    car_id BIGINT NOT NULL COMMENT '车辆ID',
    store_id BIGINT NOT NULL COMMENT '门店ID',
    appointment_time DATETIME NOT NULL COMMENT '预约时间',
    contact_name VARCHAR(50) NOT NULL COMMENT '联系人姓名',
    contact_phone VARCHAR(20) NOT NULL COMMENT '联系电话',
    status TINYINT DEFAULT 0 COMMENT '状态(0:待审核,1:已通过,2:已拒绝,3:已完成)',
    admin_remark VARCHAR(500) COMMENT '管理员备注',
    user_remark VARCHAR(500) COMMENT '用户备注',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_user_id (user_id),
    INDEX idx_car_id (car_id),
    INDEX idx_status (status),
    FOREIGN KEY (car_id) REFERENCES car(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='试驾预约表';

-- 门店表
CREATE TABLE store (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL COMMENT '门店名称',
    address VARCHAR(200) NOT NULL COMMENT '门店地址',
    phone VARCHAR(20) COMMENT '联系电话',
    business_hours VARCHAR(100) COMMENT '营业时间',
    latitude DECIMAL(10,6) COMMENT '纬度',
    longitude DECIMAL(10,6) COMMENT '经度',
    status TINYINT DEFAULT 1 COMMENT '状态(0:关闭,1:营业)',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='门店表';
