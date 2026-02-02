#!/bin/bash
echo "🔧 修复BigDecimal导入问题"
echo "======================="

echo "1. 修复Car.java..."
cat > src/main/java/com/evsales/entity/Car.java << 'CAR'
package com.evsales.entity;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class Car {
    private Long id;
    private String name;
    private String brand;
    private String model;
    private Integer rangeKm;
    private String batteryType;
    private BigDecimal price;
    private Integer stock;
    private Integer status;
    private LocalDateTime createTime;
}
CAR

echo "2. 修复CarMapper.java..."
cat > src/main/java/com/evsales/mapper/CarMapper.java << 'MAPPER'
package com.evsales.mapper;

import com.evsales.entity.Car;
import org.apache.ibatis.annotations.*;
import java.math.BigDecimal;
import java.util.List;

@Mapper
public interface CarMapper {
    
    @Select("SELECT * FROM car WHERE status = 1")
    List<Car> findAll();
    
    @Select("SELECT * FROM car WHERE id = #{id}")
    Car findById(Long id);
    
    @Select("<script>" +
            "SELECT * FROM car WHERE status = 1 " +
            "<if test='brand != null'> AND brand = #{brand} </if>" +
            "<if test='minPrice != null'> AND price >= #{minPrice} </if>" +
            "<if test='maxPrice != null'> AND price <= #{maxPrice} </if>" +
            "<if test='minRange != null'> AND range_km >= #{minRange} </if>" +
            "<if test='maxRange != null'> AND range_km <= #{maxRange} </if>" +
            "</script>")
    List<Car> findByCondition(@Param("brand") String brand,
                             @Param("minPrice") BigDecimal minPrice,
                             @Param("maxPrice") BigDecimal maxPrice,
                             @Param("minRange") Integer minRange,
                             @Param("maxRange") Integer maxRange);
    
    @Insert("INSERT INTO car (name, brand, model, range_km, battery_type, price, stock) " +
            "VALUES (#{name}, #{brand}, #{model}, #{rangeKm}, #{batteryType}, #{price}, #{stock})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(Car car);
    
    @Update("UPDATE car SET name=#{name}, brand=#{brand}, model=#{model}, range_km=#{rangeKm}, " +
            "battery_type=#{batteryType}, price=#{price}, stock=#{stock} WHERE id=#{id}")
    int update(Car car);
    
    @Update("UPDATE car SET status=0 WHERE id=#{id}")
    int deleteById(Long id);
    
    @Select("SELECT * FROM car WHERE stock <= #{threshold} AND status = 1")
    List<Car> findLowStock(Integer threshold);
    
    @Select("SELECT DISTINCT brand FROM car WHERE status = 1")
    List<String> findAllBrands();
}
MAPPER

echo "3. 修复CarService.java..."
cat > src/main/java/com/evsales/service/CarService.java << 'SERVICE'
package com.evsales.service;

import com.evsales.entity.Car;
import java.math.BigDecimal;
import java.util.List;

public interface CarService {
    List<Car> getAllCars();
    Car getCarById(Long id);
    List<Car> searchCars(String brand, BigDecimal minPrice, BigDecimal maxPrice, 
                        Integer minRange, Integer maxRange);
    boolean addCar(Car car);
    boolean updateCar(Car car);
    boolean deleteCar(Long id);
    List<Car> getLowStockCars(Integer threshold);
    List<String> getAllBrands();
}
SERVICE

echo "4. 重新编译..."
mvn compile

if [ $? -eq 0 ]; then
    echo "✅ 编译成功！"
    echo "Spring Boot会自动热重启，等待几秒后测试。"
else
    echo "❌ 编译失败，查看错误："
    mvn compile 2>&1 | tail -20
fi
