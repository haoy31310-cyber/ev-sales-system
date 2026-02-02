#!/bin/bash
echo "🚀 Spring Boot启动诊断"
echo "===================="

# 1. 后台启动并捕获日志
echo "启动Spring Boot（后台运行）..."
nohup mvn spring-boot:run > startup.log 2>&1 &
SPRING_PID=$!

echo "进程ID: $SPRING_PID"
echo "等待10秒启动..."

# 2. 等待并检查
for i in {1..10}; do
    echo -n "."
    sleep 1
    
    # 检查是否在运行
    if ! ps -p $SPRING_PID > /dev/null; then
        echo -e "\n❌ Spring Boot进程已退出"
        echo "查看错误日志:"
        tail -n 50 startup.log
        exit 1
    fi
    
    # 检查端口是否监听
    if netstat -tln 2>/dev/null | grep -q :8080; then
        echo -e "\n✅ 端口8080已监听"
        echo "测试应用..."
        curl -s http://localhost:8080/ | head -5
        kill $SPRING_PID 2>/dev/null
        exit 0
    fi
done

echo -e "\n⏳ 启动较慢，查看日志..."
tail -n 30 startup.log

echo -e "\n进程状态:"
ps -p $SPRING_PID -o pid,stat,cmd

# 清理
kill $SPRING_PID 2>/dev/null
