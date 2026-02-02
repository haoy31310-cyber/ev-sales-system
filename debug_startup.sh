#!/bin/bash
echo "🔍 详细启动诊断"
echo "============="

echo "1. 检查Java版本..."
java -version

echo -e "\n2. 检查Maven配置..."
mvn --version

echo -e "\n3. 清理并编译..."
mvn clean compile 2>&1 | tail -20

echo -e "\n4. 检查Application类..."
find src/main/java -name "Application.java" -exec cat {} \;

echo -e "\n5. 检查依赖冲突..."
mvn dependency:tree 2>&1 | grep -i "conflict\|error" || echo "未发现依赖冲突"

echo -e "\n6. 尝试直接运行（捕获完整错误）..."
echo "=== 完整错误日志开始 ==="
mvn spring-boot:run -X 2>&1 | grep -B5 -A10 "ERROR\|FAILED\|Exception" | head -100
echo "=== 完整错误日志结束 ==="

echo -e "\n7. 创建最简单的测试..."
cat > src/main/java/com/evsales/TestApp.java << 'TEST'
package com.evsales;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class TestApp {
    public static void main(String[] args) {
        System.out.println("TestApp starting...");
        SpringApplication.run(TestApp.class, args);
        System.out.println("TestApp started!");
    }
}
TEST

echo -e "\n8. 测试简化启动..."
mvn spring-boot:run -Dspring-boot.run.main-class=com.evsales.TestApp 2>&1 | tail -30
