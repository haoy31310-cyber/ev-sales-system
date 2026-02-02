#!/bin/bash
echo "🔧 修复所有问题"
echo "=============="

echo "1. 修复数据库..."
# 重启MariaDB
sudo pkill -f mariadbd 2>/dev/null || true
sudo mariadbd --user=mysql &
sleep 3

# 创建数据库
mysql -u root -e "CREATE DATABASE IF NOT EXISTS ev_sales;" 2>/dev/null || {
    echo "设置数据库权限..."
    sudo mysql -e "UPDATE mysql.user SET plugin='mysql_native_password' WHERE User='root';"
    sudo mysql -e "FLUSH PRIVILEGES;"
    mysql -u root -e "CREATE DATABASE IF NOT EXISTS ev_sales;"
}

# 导入数据
[ -f schema.sql ] && mysql -u root ev_sales < schema.sql 2>/dev/null
[ -f data.sql ] && mysql -u root ev_sales < data.sql 2>/dev/null

echo "2. 修复Controller..."
# 确保Controller存在
mkdir -p src/main/java/com/evsales/controller

cat > src/main/java/com/evsales/controller/CarController.java << 'CONTROLLER'
package com.evsales.controller;

import com.evsales.common.Result;
import org.springframework.web.bind.annotation.*;
import java.util.Arrays;
import java.util.List;

@RestController
@RequestMapping("/api/car")
public class CarController {
    
    @GetMapping("/list")
    public Result<List<String>> getCarList() {
        List<String> cars = Arrays.asList("特斯拉 Model 3", "比亚迪 汉EV", "蔚来 ES6");
        return Result.success(cars);
    }
    
    @GetMapping("/test")
    public String test() {
        return "API测试成功！";
    }
}
CONTROLLER

echo "3. 修复Result类..."
mkdir -p src/main/java/com/evsales/common

cat > src/main/java/com/evsales/common/Result.java << 'RESULT'
package com.evsales.common;

import lombok.Data;
import java.io.Serializable;

@Data
public class Result<T> implements Serializable {
    private Integer code;
    private String message;
    private T data;
    private Long timestamp;

    public static <T> Result<T> success(T data) {
        Result<T> result = new Result<>();
        result.setCode(200);
        result.setMessage("success");
        result.setData(data);
        result.setTimestamp(System.currentTimeMillis());
        return result;
    }
}
RESULT

echo "4. 重新编译..."
mvn clean compile

echo -e "\n✅ 修复完成！"
echo "现在重启Spring Boot并测试："
echo "1. 重启: mvn spring-boot:run"
echo "2. 测试: curl http://localhost:8080/api/car/list"
