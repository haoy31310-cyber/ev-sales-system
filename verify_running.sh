#!/bin/bash
echo "🔍 验证Spring Boot运行状态"
echo "========================"

echo "1. 检查端口8080:"
if netstat -tln 2>/dev/null | grep -q :8080; then
    echo "✅ 端口8080正在监听"
else
    echo "❌ 端口8080未监听"
fi

echo -e "\n2. 检查Spring Boot进程:"
PROCESS=$(ps aux | grep -E "java.*spring-boot" | grep -v grep)
if [ -n "$PROCESS" ]; then
    echo "✅ Spring Boot进程在运行"
    echo "   进程: $(echo $PROCESS | awk '{print $2, $11, $12}')"
else
    echo "❌ 未找到Spring Boot进程"
fi

echo -e "\n3. 测试HTTP访问:"
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/ 2>/dev/null)
if [[ $RESPONSE =~ 2[0-9][0-9]|404 ]]; then
    echo "✅ HTTP服务响应正常 (HTTP $RESPONSE)"
    echo "   内容: $(curl -s http://localhost:8080/ | head -c 50)..."
else
    echo "❌ HTTP服务无响应"
fi

echo -e "\n🎯 结论:"
echo "如果上面都显示✅，说明Spring Boot正在正常运行中"
echo "'卡住'的状态是正常的，表示服务在等待请求"
