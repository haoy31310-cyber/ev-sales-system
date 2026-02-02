#!/bin/bash
echo "🔧 修复404错误"
echo "============"

# 停止应用
pkill -f spring-boot 2>/dev/null
sleep 2

echo "1. 确保Application类正确..."
mkdir -p src/main/java/com/evsales

cat > src/main/java/com/evsales/Application.java << 'APP'
package com.evsales;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        System.out.println("==================================");
        System.out.println("🚗 新能源汽车销售系统");
        System.out.println("==================================");
        SpringApplication.run(Application.class, args);
    }
}
APP

echo "2. 创建测试Controller（确认扫描）..."
cat > src/main/java/com/evsales/TestController.java << 'TEST'
package com.evsales;

import org.springframework.web.bind.annotation.*;

@RestController
public class TestController {
    
    @GetMapping("/")
    public String home() {
        return "🚗 新能源汽车销售系统 API";
    }
    
    @GetMapping("/ping")
    public String ping() {
        return "pong";
    }
    
    @GetMapping("/test")
    public String test() {
        return "Test endpoint is working!";
    }
}
TEST

echo "3. 简化CarController路径..."
cat > src/main/java/com/evsales/controller/CarController.java << 'CAR'
package com.evsales.controller;

import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/cars")
public class CarController {
    
    @GetMapping("/list")
    public String getCars() {
        return "Car list would be here";
    }
    
    @GetMapping("/test")
    public String test() {
        return "CarController is working!";
    }
}
CAR

echo "4. 简化配置文件..."
cat > src/main/resources/application.yml << 'CONFIG'
server:
  port: 8080
spring:
  main:
    web-application-type: servlet
logging:
  level:
    org.springframework: INFO
    com.evsales: DEBUG
CONFIG

echo "5. 编译..."
mvn clean compile

if [ $? -eq 0 ]; then
    echo "✅ 编译成功！"
    echo ""
    echo "🚀 启动应用..."
    echo "等待10秒后测试..."
    
    # 启动
    mvn spring-boot:run > app.log 2>&1 &
    SPRING_PID=$!
    
    sleep 10
    
    echo "测试基础接口:"
    echo "1. 首页:"
    curl -s http://localhost:8080/
    
    echo -e "\n2. ping接口:"
    curl -s http://localhost:8080/ping
    
    echo -e "\n3. test接口:"
    curl -s http://localhost:8080/test
    
    echo -e "\n4. CarController测试:"
    curl -s http://localhost:8080/cars/test
    
    echo -e "\n如果看到响应，说明扫描正常！"
    
    # 停止应用
    kill $SPRING_PID 2>/dev/null
else
    echo "❌ 编译失败"
fi
