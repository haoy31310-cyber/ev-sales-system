#!/bin/bash
echo "🔄 强制重启Spring Boot"
echo "==================="

echo "1. 停止所有相关进程..."
sudo pkill -9 -f spring-boot 2>/dev/null || true
sudo pkill -9 -f java 2>/dev/null || true
sleep 3

echo "2. 检查并释放端口8080..."
if command -v lsof &> /dev/null; then
    sudo lsof -ti:8080 | xargs sudo kill -9 2>/dev/null || true
fi

echo "3. 等待进程清理..."
sleep 2

echo "4. 检查进程状态..."
PROCESSES=$(ps aux | grep -E "(java|spring)" | grep -v grep)
if [ -n "$PROCESSES" ]; then
    echo "❌ 仍有进程在运行:"
    echo "$PROCESSES"
    exit 1
else
    echo "✅ 所有进程已停止"
fi

echo "5. 重新编译..."
mvn compile 2>&1 | tail -5

echo "6. 启动Spring Boot..."
echo "=========================================="
echo "如果启动成功，请在新终端中测试:"
echo "curl http://localhost:8080/ping"
echo "=========================================="
echo ""
mvn spring-boot:run
