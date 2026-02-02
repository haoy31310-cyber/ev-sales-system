#!/bin/bash
echo "🛍️ 创建促销活动模块"
echo "================"

# 1. 创建促销活动实体
cat > src/main/java/com/evsales/entity/Promotion.java << 'PROMO'
package com.evsales.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class Promotion {
    private Long id;
    private String title;           // 活动标题
    private String description;     // 活动描述
    private String discountType;    // 折扣类型: percentage(百分比), fixed(固定金额), gift(赠品)
    private Double discountValue;   // 折扣值
    private String giftDescription; // 赠品描述
    private LocalDateTime startTime; // 开始时间
    private LocalDateTime endTime;   // 结束时间
    private String status;          // 状态: ACTIVE, INACTIVE
    private LocalDateTime createTime;
}
PROMO

# 2. 创建车辆-促销关联实体
cat > src/main/java/com/evsales/entity/CarPromotion.java << 'CARPROMO'
package com.evsales.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class CarPromotion {
    private Long id;
    private Long carId;
    private Long promotionId;
    private LocalDateTime createTime;
}
CARPROMO

# 3. 创建PromotionMapper
cat > src/main/java/com/evsales/mapper/PromotionMapper.java << 'PMAPPER'
package com.evsales.mapper;

import com.evsales.entity.Promotion;
import org.apache.ibatis.annotations.*;
import java.time.LocalDateTime;
import java.util.List;

@Mapper
public interface PromotionMapper {
    
    // 查询所有促销活动
    @Select("SELECT * FROM promotion ORDER BY create_time DESC")
    List<Promotion> findAll();
    
    // 查询进行中的促销活动
    @Select("SELECT * FROM promotion WHERE status = 'ACTIVE' AND start_time <= NOW() AND end_time >= NOW()")
    List<Promotion> findActivePromotions();
    
    // 根据ID查询
    @Select("SELECT * FROM promotion WHERE id = #{id}")
    Promotion findById(Long id);
    
    // 插入促销活动
    @Insert("INSERT INTO promotion (title, description, discount_type, discount_value, gift_description, " +
            "start_time, end_time, status) VALUES (#{title}, #{description}, #{discountType}, #{discountValue}, " +
            "#{giftDescription}, #{startTime}, #{endTime}, #{status})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(Promotion promotion);
    
    // 更新促销活动
    @Update("UPDATE promotion SET title=#{title}, description=#{description}, discount_type=#{discountType}, " +
            "discount_value=#{discountValue}, gift_description=#{giftDescription}, start_time=#{startTime}, " +
            "end_time=#{endTime}, status=#{status} WHERE id=#{id}")
    int update(Promotion promotion);
    
    // 删除促销活动
    @Delete("DELETE FROM promotion WHERE id = #{id}")
    int deleteById(Long id);
    
    // 关联车辆和促销活动
    @Insert("INSERT INTO car_promotion (car_id, promotion_id) VALUES (#{carId}, #{promotionId})")
    int linkCarPromotion(@Param("carId") Long carId, @Param("promotionId") Long promotionId);
    
    // 解除关联
    @Delete("DELETE FROM car_promotion WHERE car_id = #{carId} AND promotion_id = #{promotionId}")
    int unlinkCarPromotion(@Param("carId") Long carId, @Param("promotionId") Long promotionId);
    
    // 查询车辆的促销活动
    @Select("SELECT p.* FROM promotion p " +
            "JOIN car_promotion cp ON p.id = cp.promotion_id " +
            "WHERE cp.car_id = #{carId} AND p.status = 'ACTIVE' " +
            "AND p.start_time <= NOW() AND p.end_time >= NOW()")
    List<Promotion> findPromotionsByCarId(Long carId);
}
PMAPPER

# 4. 创建数据库表
cat > promotion_schema.sql << 'SQL'
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
SQL

echo "✅ 促销活动模块代码已创建！"
echo "数据库脚本: promotion_schema.sql"
echo "实体类: Promotion.java, CarPromotion.java"
echo "Mapper: PromotionMapper.java"
