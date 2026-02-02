package com.evsales.mapper;

import com.evsales.entity.Car;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface CarMapper {
    
    // 查询所有上架车辆
    @Select("SELECT * FROM car WHERE status = 1")
    List<Car> findAll();
    
    // 根据ID查询
    @Select("SELECT * FROM car WHERE id = #{id}")
    Car findById(Long id);
    
    // 简单条件查询（先不用动态SQL）
    @Select("SELECT * FROM car WHERE status = 1 AND brand = #{brand}")
    List<Car> findByBrand(String brand);
    
    @Select("SELECT * FROM car WHERE status = 1 AND price BETWEEN #{minPrice} AND #{maxPrice}")
    List<Car> findByPriceRange(@Param("minPrice") Double minPrice, @Param("maxPrice") Double maxPrice);
    
    @Select("SELECT * FROM car WHERE status = 1 AND range_km >= #{minRange}")
    List<Car> findByMinRange(Integer minRange);
    
    // 插入车辆
    @Insert("INSERT INTO car (name, brand, model, range_km, battery_type, price, stock) " +
            "VALUES (#{name}, #{brand}, #{model}, #{rangeKm}, #{batteryType}, #{price}, #{stock})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(Car car);
    
    // 更新车辆
    @Update("UPDATE car SET name=#{name}, brand=#{brand}, model=#{model}, range_km=#{rangeKm}, " +
            "battery_type=#{batteryType}, price=#{price}, stock=#{stock} WHERE id=#{id}")
    int update(Car car);
    
    // 逻辑删除
    @Update("UPDATE car SET status=0 WHERE id=#{id}")
    int deleteById(Long id);
    
    // 查询库存不足车辆
    @Select("SELECT * FROM car WHERE stock <= #{threshold} AND status = 1")
    List<Car> findLowStock(Integer threshold);
    
    // 查询所有品牌
    @Select("SELECT DISTINCT brand FROM car WHERE status = 1")
    List<String> findAllBrands();
    
    // 更新库存
    @Update("UPDATE car SET stock = stock - #{quantity} WHERE id = #{carId} AND stock >= #{quantity}")
    int reduceStock(@Param("carId") Long carId, @Param("quantity") Integer quantity);
}
