package com.evsales.service;

import com.evsales.entity.Promotion;
import java.util.List;

public interface PromotionService {
    
    // 获取所有促销活动
    List<Promotion> getAllPromotions();
    
    // 获取进行中的促销活动
    List<Promotion> getActivePromotions();
    
    // 根据ID获取促销活动
    Promotion getPromotionById(Long id);
    
    // 创建促销活动
    boolean createPromotion(Promotion promotion);
    
    // 更新促销活动
    boolean updatePromotion(Promotion promotion);
    
    // 删除促销活动
    boolean deletePromotion(Long id);
    
    // 关联车辆和促销
    boolean linkCarToPromotion(Long carId, Long promotionId);
    
    // 解除关联
    boolean unlinkCarFromPromotion(Long carId, Long promotionId);
    
    // 获取车辆的促销活动
    List<Promotion> getPromotionsByCarId(Long carId);
    
    // 检查促销活动是否有效
    boolean isPromotionValid(Promotion promotion);
}
