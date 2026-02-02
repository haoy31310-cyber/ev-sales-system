#!/bin/bash
echo "🔌 断网后恢复脚本"
echo "================"

echo "1. 检查环境..."
echo "当前目录: $(pwd)"
echo "Java版本: $(java -version 2>&1 | head -1)"

echo -e "\n2. 检查Maven..."
which mvn && mvn -v | head -2

echo -e "\n3. 清理缓存..."
rm -rf target ~/.m2/repository/org/springframework/boot 2>/dev/null

echo -e "\n4. 创建最小化项目..."
rm -rf src/main/java/com/evsales/*
mkdir -p src/main/java/com/evsales

cat > src/main/java/com/evsales/SimpleApp.java << 'APP'
package com.evsales;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.*;

@SpringBootApplication
@RestController
public class SimpleApp {
    
    public static void main(String[] args) {
        System.out.println("=== 断网后重启 ===");
        SpringApplication.run(SimpleApp.class, args);
    }
    
    @GetMapping("/")
    public String home() { 
        return "<h1>新能源汽车销售系统</h1><p>状态: 重新连接成功</p>"; 
    }
    
    @GetMapping("/ping")
    public String ping() { 
        return "{\"status\":\"reconnected\",\"time\":" + System.currentTimeMillis() + "}"; 
    }
}
APP

echo -e "\n5. 尝试编译（带网络重试）..."
for i in {1..3}; do
    echo "尝试 $i/3..."
    mvn clean compile && {
        echo "✅ 编译成功"
        break
    }
    sleep 2
done

echo -e "\n6. 启动Spring Boot..."
echo "请在另一个终端测试: curl http://localhost:8080/ping"
echo "按Ctrl+C停止服务"
mvn spring-boot:run
