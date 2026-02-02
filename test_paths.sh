#!/bin/bash
echo "🔍 测试所有可用路径"
echo "================="

BASE_URL="http://localhost:8080"
PATHS=(
    "/"
    "/ping"
    "/api/car/test"
    "/api/car/list"
    "/api/car/health"
    "/actuator/health"
    "/actuator"
)

for path in "${PATHS[@]}"; do
    echo -n "测试 $path ... "
    status=$(curl -s -o /dev/null -w "%{http_code}" "${BASE_URL}${path}")
    if [[ $status == 200 ]]; then
        echo "✅ 成功 ($status)"
        echo "   响应: $(curl -s "${BASE_URL}${path}" | head -1 | cut -c1-50)..."
    elif [[ $status == 404 ]]; then
        echo "❌ 404 (路径不存在)"
    else
        echo "⚠️  $status"
    fi
done

echo -e "\n🎯 建议："
echo "1. 如果 /api/car/test 返回404，检查CarController是否存在"
echo "2. 运行: find src/main/java -name '*Controller.java'"
echo "3. 运行: mvn compile 重新编译"
