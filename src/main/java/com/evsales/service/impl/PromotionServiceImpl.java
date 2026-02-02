package com.evsales.service.impl;

import com.evsales.entity.Promotion;
import com.evsales.mapper.PromotionMapper;
import com.evsales.service.PromotionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class PromotionServiceImpl implements PromotionService {
    
    @Autowired
    private PromotionMapper promotionMapper;
    
    @Override
    public List<Promotion> getAllPromotions() {
        return promotionMapper.findAll();
    }
    
    @Override
    public List<Promotion> getActivePromotions() {
        return promotionMapper.findActivePromotions();
    }
    
    @Override
    public Promotion getPromotionById(Long id) {
        return promotionMapper.findById(id);
    }
    
    @Override
    @Transactional
    public boolean createPromotion(Promotion promotion) {
        // 设置默认状态
        if (promotion.getStatus() == null) {
            promotion.setStatus("ACTIVE");
        }
        return promotionMapper.insert(promotion) > 0;
    }
    
    @Override
    @Transactional
    public boolean updatePromotion(Promotion promotion) {
        return promotionMapper.update(promotion) > 0;
    }
    
    @Override
    @Transactional
    public boolean deletePromotion(Long id) {
        return promotionMapper.deleteById(id) > 0;
    }
    
    @Override
    @Transactional
    public boolean linkCarToPromotion(Long carId, Long promotionId) {
        return promotionMapper.linkCarPromotion(carId, promotionId) > 0;
    }
    
    @Override
    @Transactional
    public boolean unlinkCarFromPromotion(Long carId, Long promotionId) {
        return promotionMapper.unlinkCarPromotion(carId, promotionId) > 0;
    }
    
    @Override
    public List<Promotion> getPromotionsByCarId(Long carId) {
        return promotionMapper.findPromotionsByCarId(carId);
    }
    
    @Override
    public boolean isPromotionValid(Promotion promotion) {
        if (promotion == null) return false;
        if (!"ACTIVE".equals(promotion.getStatus())) return false;
        
        LocalDateTime now = LocalDateTime.now();
        return !now.isBefore(promotion.getStartTime()) && !now.isAfter(promotion.getEndTime());
    }
}
