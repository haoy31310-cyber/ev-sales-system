#!/bin/bash
echo "🚗 新能源汽车销售系统 API 测试"
echo "=================================="

BASE_URL="http://localhost:8080"

echo "1. 测试车辆列表接口..."
curl -s -X GET "${BASE_URL}/api/car/list" | python3 -m json.tool

echo -e "\n2. 测试搜索接口（特斯拉）..."
curl -s -X GET "${BASE_URL}/api/car/search?brand=特斯拉" | python3 -m json.tool

echo -e "\n3. 测试获取所有品牌..."
curl -s -X GET "${BASE_URL}/api/car/brands" | python3 -m json.tool

echo -e "\n4. 测试获取车辆详情（ID=1）..."
curl -s -X GET "${BASE_URL}/api/car/1" | python3 -m json.tool

echo -e "\n✅ 测试完成！"
