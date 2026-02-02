#!/bin/bash
echo "🔧 修复接口不匹配问题"
echo "=================="

echo "1. 修复CarService接口..."
cat > src/main/java/com/evsales/service/CarService.java << 'SERVICE'
package com.evsales.service;

import com.evsales.entity.Car;
import java.util.List;

public interface CarService {
    List<Car> getAllCars();
    Car getCarById(Long id);
    List<Car> searchCars(String brand, Double minPrice, Double maxPrice);
    List<Car> searchCarsFull(String brand, Double minPrice, Double maxPrice, 
                           Integer minRange, Integer maxRange);
    boolean addCar(Car car);
    boolean updateCar(Car car);
    boolean deleteCar(Long id);
    List<Car> getLowStockCars(Integer threshold);
    List<String> getAllBrands();
}
SERVICE

echo "2. 修复CarMapper..."
cat > src/main/java/com/evsales/mapper/CarMapper.java << 'MAPPER'
package com.evsales.mapper;

import com.evsales.entity.Car;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface CarMapper {
    @Select("SELECT * FROM car WHERE status = 1")
    List<Car> findAll();
    
    @Select("SELECT * FROM car WHERE id = #{id}")
    Car findById(Long id);
    
    @Select("SELECT * FROM car WHERE status = 1 AND brand = #{brand}")
    List<Car> findByBrand(String brand);
    
    @Select("SELECT * FROM car WHERE status = 1 AND price BETWEEN #{minPrice} AND #{maxPrice}")
    List<Car> findByPriceRange(@Param("minPrice") Double minPrice, @Param("maxPrice") Double maxPrice);
    
    @Select("SELECT * FROM car WHERE status = 1 AND range_km BETWEEN #{minRange} AND #{maxRange}")
    List<Car> findByRange(@Param("minRange") Integer minRange, @Param("maxRange") Integer maxRange);
    
    @Insert("INSERT INTO car (name, brand, model, range_km, battery_type, price, stock) VALUES (#{name}, #{brand}, #{model}, #{rangeKm}, #{batteryType}, #{price}, #{stock})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(Car car);
    
    @Update("UPDATE car SET name=#{name}, brand=#{brand}, model=#{model}, range_km=#{rangeKm}, battery_type=#{batteryType}, price=#{price}, stock=#{stock} WHERE id=#{id}")
    int update(Car car);
    
    @Update("UPDATE car SET status=0 WHERE id=#{id}")
    int deleteById(Long id);
    
    @Select("SELECT * FROM car WHERE stock <= #{threshold} AND status = 1")
    List<Car> findLowStock(Integer threshold);
    
    @Select("SELECT DISTINCT brand FROM car WHERE status = 1")
    List<String> findAllBrands();
}
MAPPER

echo "3. 修复CarServiceImpl..."
cat > src/main/java/com/evsales/service/impl/CarServiceImpl.java << 'IMPL'
package com.evsales.service.impl;

import com.evsales.entity.Car;
import com.evsales.mapper.CarMapper;
import com.evsales.service.CarService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class CarServiceImpl implements CarService {
    
    @Autowired
    private CarMapper carMapper;
    
    @Override
    public List<Car> getAllCars() {
        return carMapper.findAll();
    }
    
    @Override
    public Car getCarById(Long id) {
        return carMapper.findById(id);
    }
    
    @Override
    public List<Car> searchCars(String brand, Double minPrice, Double maxPrice) {
        if (brand != null && !brand.isEmpty()) {
            return carMapper.findByBrand(brand);
        }
        return carMapper.findAll();
    }
    
    @Override
    public List<Car> searchCarsFull(String brand, Double minPrice, Double maxPrice, 
                                  Integer minRange, Integer maxRange) {
        List<Car> allCars = carMapper.findAll();
        return allCars.stream()
            .filter(car -> brand == null || brand.isEmpty() || brand.equals(car.getBrand()))
            .filter(car -> minPrice == null || car.getPrice() >= minPrice)
            .filter(car -> maxPrice == null || car.getPrice() <= maxPrice)
            .filter(car -> minRange == null || car.getRangeKm() >= minRange)
            .filter(car -> maxRange == null || car.getRangeKm() <= maxRange)
            .collect(Collectors.toList());
    }
    
    @Override
    @Transactional
    public boolean addCar(Car car) {
        car.setStatus(1);
        return carMapper.insert(car) > 0;
    }
    
    @Override
    @Transactional
    public boolean updateCar(Car car) {
        return carMapper.update(car) > 0;
    }
    
    @Override
    @Transactional
    public boolean deleteCar(Long id) {
        return carMapper.deleteById(id) > 0;
    }
    
    @Override
    public List<Car> getLowStockCars(Integer threshold) {
        return carMapper.findLowStock(threshold == null ? 5 : threshold);
    }
    
    @Override
    public List<String> getAllBrands() {
        return carMapper.findAllBrands();
    }
}
IMPL

echo "4. 修复CarController..."
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
        result.put("code", 200);
        result.put("message", "success");
        result.put("data", carService.getAllCars());
        result.put("total", carService.getAllCars().size());
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
            cars = carService.searchCarsFull(brand, minPrice, maxPrice, minRange, maxRange);
        } else {
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
    
    @GetMapping("/low-stock")
    public Map<String, Object> getLowStockCars(
            @RequestParam(required = false, defaultValue = "5") Integer threshold) {
        Map<String, Object> result = new HashMap<>();
        List<Car> cars = carService.getLowStockCars(threshold);
        result.put("code", 200);
        result.put("message", "success");
        result.put("data", cars);
        result.put("count", cars.size());
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

echo "5. 重新编译..."
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
    echo "❌ 编译失败，请查看错误信息"
    mvn compile 2>&1 | grep -i "error" | head -10
fi
