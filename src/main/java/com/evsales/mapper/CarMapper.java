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
