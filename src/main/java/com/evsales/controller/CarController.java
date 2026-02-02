package com.evsales.controller;

import com.evsales.entity.Car;
import com.evsales.service.CarService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/car")
public class CarController {
    
    @Autowired
    private CarService carService;
    
    // 1. 获取所有车辆
    @GetMapping("/list")
    public Map<String, Object> getAllCars() {
        Map<String, Object> result = new HashMap<>();
        try {
            List<Car> cars = carService.getAllCars();
            result.put("code", 200);
            result.put("message", "success");
            result.put("data", cars);
            result.put("total", cars.size());
        } catch (Exception e) {
            result.put("code", 500);
            result.put("message", "服务器错误: " + e.getMessage());
        }
        return result;
    }
    
    // 2. 获取车辆详情
    @GetMapping("/{id}")
    public Map<String, Object> getCarById(@PathVariable Long id) {
        Map<String, Object> result = new HashMap<>();
        try {
            Car car = carService.getCarById(id);
            if (car != null) {
                result.put("code", 200);
                result.put("message", "success");
                result.put("data", car);
            } else {
                result.put("code", 404);
                result.put("message", "车辆不存在");
            }
        } catch (Exception e) {
            result.put("code", 500);
            result.put("message", "服务器错误: " + e.getMessage());
        }
        return result;
    }
    
    // 3. 条件搜索
    @GetMapping("/search")
    public Map<String, Object> searchCars(
            @RequestParam(required = false) String brand,
            @RequestParam(required = false) Double minPrice,
            @RequestParam(required = false) Double maxPrice) {
        
        Map<String, Object> result = new HashMap<>();
        try {
            List<Car> cars = carService.searchCars(brand, minPrice, maxPrice);
            result.put("code", 200);
            result.put("message", "success");
            result.put("data", cars);
            result.put("total", cars.size());
        } catch (Exception e) {
            result.put("code", 500);
            result.put("message", "服务器错误: " + e.getMessage());
        }
        return result;
    }
    
    // 4. 获取所有品牌
    @GetMapping("/brands")
    public Map<String, Object> getAllBrands() {
        Map<String, Object> result = new HashMap<>();
        try {
            List<String> brands = carService.getAllBrands();
            result.put("code", 200);
            result.put("message", "success");
            result.put("data", brands);
        } catch (Exception e) {
            result.put("code", 500);
            result.put("message", "服务器错误: " + e.getMessage());
        }
        return result;
    }
    
    // 5. 库存不足车辆
    @GetMapping("/low-stock")
    public Map<String, Object> getLowStockCars(
            @RequestParam(required = false, defaultValue = "5") Integer threshold) {
        
        Map<String, Object> result = new HashMap<>();
        try {
            List<Car> cars = carService.getLowStockCars(threshold);
            result.put("code", 200);
            result.put("message", "success");
            result.put("data", cars);
            result.put("count", cars.size());
            result.put("threshold", threshold);
        } catch (Exception e) {
            result.put("code", 500);
            result.put("message", "服务器错误: " + e.getMessage());
        }
        return result;
    }
    
    // 6. 测试接口
    @GetMapping("/ping")
    public String ping() {
        return "Car module is working";
    }
}
