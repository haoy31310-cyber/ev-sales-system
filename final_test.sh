#!/bin/bash
echo "🎯 最终测试"
echo "=========="

BASE_URL="http://localhost:8080"

echo "1. 首页:"
curl -s "${BASE_URL}/" | head -3

echo -e "\n2. Ping测试:"
curl -s "${BASE_URL}/ping"

echo -e "\n3. 车辆测试:"
curl -s "${BASE_URL}/api/car/test"

echo -e "\n4. 车辆列表:"
curl -s "${BASE_URL}/api/car/list" | head -5

echo -e "\n5. 车辆健康检查:"
curl -s "${BASE_URL}/api/car/health"

echo -e "\n6. 单个车辆:"
curl -s "${BASE_URL}/api/car/1"

echo -e "\n✅ 测试完成！如果看到数据，说明修复成功。"
