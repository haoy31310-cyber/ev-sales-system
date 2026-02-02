package com.evsales.controller;

import com.evsales.entity.Promotion;
import com.evsales.service.PromotionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/promotion")
public class PromotionController {
    
    @Autowired
    private PromotionService promotionService;
    
    // 1. 获取所有促销活动
    @GetMapping("/list")
    public Map<String, Object> getAllPromotions() {
        Map<String, Object> result = new HashMap<>();
        try {
            List<Promotion> promotions = promotionService.getAllPromotions();
            result.put("code", 200);
            result.put("message", "success");
            result.put("data", promotions);
            result.put("total", promotions.size());
        } catch (Exception e) {
            result.put("code", 500);
            result.put("message", "服务器错误: " + e.getMessage());
        }
        return result;
    }
    
    // 2. 获取进行中的促销
    @GetMapping("/active")
    public Map<String, Object> getActivePromotions() {
        Map<String, Object> result = new HashMap<>();
        try {
            List<Promotion> promotions = promotionService.getActivePromotions();
            result.put("code", 200);
            result.put("message", "success");
            result.put("data", promotions);
        } catch (Exception e) {
            result.put("code", 500);
            result.put("message", "服务器错误: " + e.getMessage());
        }
        return result;
    }
    
    // 3. 获取车辆的促销活动
    @GetMapping("/car/{carId}")
    public Map<String, Object> getPromotionsByCarId(@PathVariable Long carId) {
        Map<String, Object> result = new HashMap<>();
        try {
            List<Promotion> promotions = promotionService.getPromotionsByCarId(carId);
            result.put("code", 200);
            result.put("message", "success");
            result.put("data", promotions);
            result.put("carId", carId);
        } catch (Exception e) {
            result.put("code", 500);
            result.put("message", "服务器错误: " + e.getMessage());
        }
        return result;
    }
    
    // 4. 测试接口
    @GetMapping("/ping")
    public String ping() {
        return "Promotion module is working";
    }
}
