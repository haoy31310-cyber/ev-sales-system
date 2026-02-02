#!/bin/bash
echo "🔍 Spring Boot启动诊断"
echo "==================="

echo "1. 检查依赖..."
mvn dependency:tree 2>&1 | grep -A5 -B5 "ERROR\|FAILED" || echo "✅ 依赖正常"

echo -e "\n2. 编译状态..."
mvn compile 2>&1 | tail -10

echo -e "\n3. 检查Application类..."
find src/main/java -name "Application.java" -exec cat {} \;

echo -e "\n4. 检查是否有其他配置问题..."
ls -la src/main/resources/

echo -e "\n5. 尝试直接运行（显示所有错误）..."
mvn clean package -DskipTests 2>&1 | grep -i "error\|exception\|fail" | head -10

echo -e "\n6. 查看jar包启动日志..."
if [ -f "target/*.jar" ]; then
    java -jar target/*.jar 2>&1 | head -30
fi
