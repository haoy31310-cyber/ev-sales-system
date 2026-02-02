#!/bin/bash
echo "🔧 清理重复的Controller并修复编译错误"
echo "===================================="

echo "1. 查找并清理重复文件..."
echo "找到的CarController文件："
find . -name "CarController.java" -type f

# 删除错误的CarController
rm -f src/main/java/com/evsales/CarController.java 2>/dev/null && echo "✅ 删除根目录的CarController"
rm -f src/main/java/com/evsales/controller/CarController.java 2>/dev/null && echo "✅ 删除旧的Controller"

echo "2. 创建正确的CarController..."
mkdir -p src/main/java/com/evsales/controller

cat > src/main/java/com/evsales/controller/CarController.java << 'CTRL'
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
    
    @GetMapping("/list")
    public Map<String, Object> getAllCars() {
        Map<String, Object> result = new HashMap<>();
        List<Car> cars = carService.getAllCars();
        result.put("code", 200);
        result.put("message", "success");
        result.put("data", cars);
        result.put("total", cars.size());
        return result;
    }
    
    @GetMapping("/{id}")
    public Map<String, Object> getCarById(@PathVariable Long id) {
        Map<String, Object> result = new HashMap<>();
        Car car = carService.getCarById(id);
        if (car != null) {
            result.put("code", 200);
            result.put("message", "success");
            result.put("data", car);
        } else {
            result.put("code", 404);
            result.put("message", "车辆不存在");
        }
        return result;
    }
    
    @GetMapping("/search")
    public Map<String, Object> searchCars(
            @RequestParam(required = false) String brand,
            @RequestParam(required = false) Double minPrice,
            @RequestParam(required = false) Double maxPrice,
            @RequestParam(required = false) Integer minRange,
            @RequestParam(required = false) Integer maxRange) {
        
        Map<String, Object> result = new HashMap<>();
        List<Car> cars;
        
        if (minRange != null || maxRange != null) {
            // 使用完整搜索
            cars = carService.searchCarsFull(brand, minPrice, maxPrice, minRange, maxRange);
        } else {
            // 使用简化搜索
            cars = carService.searchCars(brand, minPrice, maxPrice);
        }
        
        result.put("code", 200);
        result.put("message", "success");
        result.put("data", cars);
        result.put("total", cars.size());
        return result;
    }
    
    @PostMapping("/add")
    public Map<String, Object> addCar(@RequestBody Car car) {
        Map<String, Object> result = new HashMap<>();
        boolean success = carService.addCar(car);
        if (success) {
            result.put("code", 200);
            result.put("message", "添加成功");
            result.put("data", car.getId());
        } else {
            result.put("code", 500);
            result.put("message", "添加失败");
        }
        return result;
    }
    
    @PutMapping("/update")
    public Map<String, Object> updateCar(@RequestBody Car car) {
        Map<String, Object> result = new HashMap<>();
        boolean success = carService.updateCar(car);
        if (success) {
            result.put("code", 200);
            result.put("message", "更新成功");
        } else {
            result.put("code", 500);
            result.put("message", "更新失败");
        }
        return result;
    }
    
    @DeleteMapping("/delete/{id}")
    public Map<String, Object> deleteCar(@PathVariable Long id) {
        Map<String, Object> result = new HashMap<>();
        boolean success = carService.deleteCar(id);
        if (success) {
            result.put("code", 200);
            result.put("message", "删除成功");
        } else {
            result.put("code", 500);
            result.put("message", "删除失败");
        }
        return result;
    }
    
    @GetMapping("/low-stock")
    public Map<String, Object> getLowStockCars(
            @RequestParam(required = false, defaultValue = "5") Integer threshold) {
        Map<String, Object> result = new HashMap<>();
        List<Car> cars = carService.getLowStockCars(threshold);
        result.put("code", 200);
        result.put("message", "success");
        result.put("data", cars);
        result.put("count", cars.size());
        result.put("threshold", threshold);
        return result;
    }
    
    @GetMapping("/brands")
    public Map<String, Object> getAllBrands() {
        Map<String, Object> result = new HashMap<>();
        result.put("code", 200);
        result.put("message", "success");
        result.put("data", carService.getAllBrands());
        return result;
    }
}
CTRL

echo "3. 检查其他重复文件..."
# 清理其他可能的重复文件
rm -f src/main/java/com/evsales/CarService.java 2>/dev/null && echo "✅ 删除根目录的CarService"
rm -f src/main/java/com/evsales/CarMapper.java 2>/dev/null && echo "✅ 删除根目录的CarMapper"

echo "4. 确保所有文件在正确位置..."
# CarService应该在service包
mkdir -p src/main/java/com/evsales/service
mkdir -p src/main/java/com/evsales/service/impl

# CarMapper应该在mapper包
mkdir -p src/main/java/com/evsales/mapper

# 实体应该在entity包
mkdir -p src/main/java/com/evsales/entity

echo "5. 检查Application主类..."
# 确保只有一个Application类
find src/main/java -name "Application.java" -o -name "*App.java" | while read file; do
    if ! echo "$file" | grep -q "controller\|service\|mapper\|entity"; then
        echo "主类: $file"
    fi
done

echo "6. 重新编译..."
mvn clean compile

if [ $? -eq 0 ]; then
    echo "✅ 编译成功！"
    echo ""
    echo "🚀 现在可以启动应用："
    echo "mvn spring-boot:run"
    echo ""
    echo "📡 启动后测试："
    echo "curl http://localhost:8080/api/car/list"
else
    echo "❌ 编译失败，错误信息："
    mvn compile 2>&1 | grep -i "error" -B2 -A2
fi
