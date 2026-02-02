package com.evsales.controller;

import org.springframework.web.bind.annotation.*;
import java.util.*;

@RestController
@RequestMapping("/api/car")
public class CarController {
    
    @GetMapping("/test")
    public String test() {
        return "🚗 车辆API测试成功 - " + new Date();
    }
    
    @GetMapping("/list")
    public List<Map<String, Object>> getCarList() {
        return Arrays.asList(
            createCar(1, "Model 3", "特斯拉", 245900, 15),
            createCar(2, "汉EV", "比亚迪", 209800, 8),
            createCar(3, "ES6", "蔚来", 338000, 5),
            createCar(4, "P7", "小鹏", 229900, 12)
        );
    }
    
    @GetMapping("/health")
    public Map<String, Object> health() {
        Map<String, Object> health = new HashMap<>();
        health.put("status", "UP");
        health.put("service", "car-service");
        health.put("timestamp", System.currentTimeMillis());
        return health;
    }
    
    @GetMapping("/{id}")
    public Map<String, Object> getCar(@PathVariable Integer id) {
        return createCar(id, "测试车型", "测试品牌", 200000, 10);
    }
    
    private Map<String, Object> createCar(Integer id, String name, String brand, Integer price, Integer stock) {
        Map<String, Object> car = new HashMap<>();
        car.put("id", id);
        car.put("name", name);
        car.put("brand", brand);
        car.put("price", price);
        car.put("stock", stock);
        car.put("createTime", new Date());
        return car;
    }
}
