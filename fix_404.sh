#!/bin/bash
echo "🔧 修复所有404路径"
echo "================="

# 1. 确保目录存在
mkdir -p src/main/java/com/evsales/controller

# 2. 修复CarController（完整版）
cat > src/main/java/com/evsales/controller/CarController.java << 'CONTROLLER'
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
CONTROLLER

# 3. 修复TestController
cat > src/main/java/com/evsales/controller/TestController.java << 'TEST'
package com.evsales.controller;

import org.springframework.web.bind.annotation.*;

@RestController
public class TestController {
    
    @GetMapping("/")
    public String home() {
        return """
            <!DOCTYPE html>
            <html>
            <head><title>新能源汽车销售系统</title></head>
            <body>
                <h1>🚗 新能源汽车销售系统 API</h1>
                <h2>可用接口：</h2>
                <ul>
                    <li><a href="/ping">/ping</a> - 连通性测试</li>
                    <li><a href="/api/car/test">/api/car/test</a> - 车辆API测试</li>
                    <li><a href="/api/car/list">/api/car/list</a> - 车辆列表</li>
                    <li><a href="/api/car/health">/api/car/health</a> - 服务健康检查</li>
                    <li><a href="/api/car/1">/api/car/1</a> - 获取车辆详情(ID=1)</li>
                </ul>
            </body>
            </html>
            """;
    }
    
    @GetMapping("/ping")
    public String ping() {
        return "pong";
    }
    
    @GetMapping("/status")
    public String status() {
        return "{\"status\":\"running\",\"timestamp\":" + System.currentTimeMillis() + "}";
    }
}
TEST

# 4. 重新编译
echo "重新编译..."
mvn compile

echo -e "\n✅ 修复完成！"
echo "重启Spring Boot或等待热重启后测试以下路径："
echo "1. http://localhost:8080/"
echo "2. http://localhost:8080/ping"
echo "3. http://localhost:8080/api/car/test"
echo "4. http://localhost:8080/api/car/list"
echo "5. http://localhost:8080/api/car/health"
echo "6. http://localhost:8080/api/car/1"
