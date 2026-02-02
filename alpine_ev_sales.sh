#!/bin/sh
echo "🚗 Alpine Linux - 新能源汽车销售系统启动"
echo "========================================"

# 1. 启动MariaDB
echo "1. 启动数据库..."
./start_mariadb.sh

# 2. 编译项目
echo -e "\n2. 编译项目..."
mvn clean compile

if [ $? -ne 0 ]; then
    echo "❌ 编译失败，请检查错误"
    exit 1
fi

# 3. 启动Spring Boot
echo -e "\n3. 启动Spring Boot..."
echo "========================================"
echo "🎉 服务正在启动..."
echo ""
echo "在新终端中测试："
echo "curl http://localhost:8080/api/car/list"
echo ""
echo "按 Ctrl+C 停止服务"
echo "========================================"
echo ""
mvn spring-boot:run
