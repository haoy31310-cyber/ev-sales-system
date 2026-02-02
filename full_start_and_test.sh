#!/bin/bash
echo "🚗 新能源汽车销售系统 - 完整启动测试"
echo "=================================="

# 清理
echo "1. 清理环境..."
pkill -9 -f spring-boot 2>/dev/null || true
pkill -9 -f java 2>/dev/null || true
sleep 2

# 编译
echo "2. 编译项目..."
mvn clean compile

if [ $? -ne 0 ]; then
    echo "❌ 编译失败！"
    exit 1
fi

# 启动后台
echo "3. 启动Spring Boot（后台运行）..."
nohup mvn spring-boot:run > app.log 2>&1 &
SPRING_PID=$!
echo "应用进程ID: $SPRING_PID"

# 等待启动
echo "4. 等待应用启动（15秒）..."
for i in {1..15}; do
    echo -n "."
    sleep 1
    if curl -s http://localhost:8080/ping > /dev/null; then
        echo -e "\n✅ 应用启动成功！"
        break
    fi
done

echo -e "\n5. 测试基础API:"
echo "ping接口: $(curl -s http://localhost:8080/ping)"
echo "首页: $(curl -s http://localhost:8080/)"

echo -e "\n6. 测试车辆API:"
echo "车辆列表:"
curl -s "http://localhost:8080/api/car/list" | head -100

echo -e "\n7. 检查数据库:"
curl -s "http://localhost:8080/api/db/test"

echo -e "\n8. 查看应用日志（最后10行）:"
tail -10 app.log

echo -e "\n9. 进程状态:"
ps -p $SPRING_PID > /dev/null && echo "✅ Spring Boot正在运行 (PID: $SPRING_PID)" || echo "❌ Spring Boot已停止"

echo -e "\n🔧 如果API没有数据，可能是："
echo "  1. 数据库没有表/数据"
echo "  2. 数据库连接配置问题"
echo "  3. Mapper配置问题"
