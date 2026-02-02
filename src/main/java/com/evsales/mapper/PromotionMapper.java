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
