#!/bin/bash
echo "🔧 修复MyBatis XML解析错误"
echo "========================"

echo "1. 备份原文件..."
mkdir -p backup
cp src/main/java/com/evsales/mapper/CarMapper.java backup/ 2>/dev/null || true

echo "2. 创建简化版的Mapper..."
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

echo "3. 简化Car实体..."
cat > src/main/java/com/evsales/entity/Car.java << 'CAR'
package com.evsales.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class Car {
    private Long id;
    private String name;
    private String brand;
    private String model;
    private Integer rangeKm;
    private String batteryType;
    private Double price;
    private Integer stock;
    private Integer status;
    private LocalDateTime createTime;
}
CAR

echo "4. 创建数据库配置..."
cat > src/main/resources/application.yml << 'CONFIG'
server:
  port: 8080
spring:
  datasource:
    url: jdbc:h2:mem:evsales;DB_CLOSE_DELAY=-1;MODE=MySQL
    driver-class-name: org.h2.Driver
    username: sa
    password: 
  h2:
    console:
      enabled: true
      path: /h2-console
  sql:
    init:
      mode: always
      schema-locations: classpath:schema.sql
      data-locations: classpath:data.sql
mybatis:
  configuration:
    map-underscore-to-camel-case: true
logging:
  level:
    com.evsales: DEBUG
CONFIG

echo "5. 创建数据库初始化脚本..."
cat > src/main/resources/schema.sql << 'SQL'
CREATE TABLE IF NOT EXISTS car (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    brand VARCHAR(50) NOT NULL,
    model VARCHAR(50),
    range_km INT NOT NULL,
    battery_type VARCHAR(50),
    price DOUBLE NOT NULL,
    stock INT DEFAULT 0,
    status INT DEFAULT 1,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
SQL

cat > src/main/resources/data.sql << 'DATA'
INSERT INTO car (name, brand, model, range_km, battery_type, price, stock) VALUES
('特斯拉 Model 3', '特斯拉', '后驱版', 556, '三元锂电池', 245900.00, 10),
('特斯拉 Model Y', '特斯拉', '长续航版', 688, '三元锂电池', 299900.00, 5),
('比亚迪 汉EV', '比亚迪', '冠军版', 715, '磷酸铁锂电池', 269800.00, 15),
('理想 L9', '理想', 'Max版', 215, '三元锂电池', 459800.00, 3),
('蔚来 ET5', '蔚来', '75kWh', 560, '三元锂电池', 298000.00, 8);
DATA

echo "6. 重新编译..."
mvn clean compile

if [ $? -eq 0 ]; then
    echo "✅ 编译成功！"
    echo ""
    echo "🚀 现在可以启动Spring Boot："
    echo "mvn spring-boot:run"
    echo ""
    echo "📡 启动后访问："
    echo "1. http://localhost:8080/ping"
    echo "2. http://localhost:8080/api/car/list"
    echo "3. http://localhost:8080/h2-console (查看数据库)"
else
    echo "❌ 编译失败，请查看错误信息"
fi
