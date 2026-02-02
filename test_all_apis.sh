#!/bin/bash
echo "🧪 测试所有API接口"
echo "================"

APIs=(
    "/"
    "/ping"
    "/api/car/list"
    "/api/car/brands"
    "/api/car/low-stock?threshold=5"
    "/api/db/test"
)

for api in "${APIs[@]}"; do
    echo -e "\n测试: $api"
    response=$(curl -s -w " [HTTP:%{http_code}]" "http://localhost:8080$api")
    echo "响应: $response"
done

echo -e "\n✅ API测试完成"
