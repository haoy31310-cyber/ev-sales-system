#!/bin/bash
echo "🧪 测试完整的车辆管理模块"
echo "======================="

echo "等待Spring Boot启动..."
sleep 3

echo "1. 获取所有车辆:"
curl -s "http://localhost:8080/api/car/list" | jq '.data | length' 2>/dev/null || \
curl -s "http://localhost:8080/api/car/list" | grep -o '"name":"[^"]*"' | head -5

echo -e "\n2. 条件搜索（品牌=特斯拉）:"
curl -s "http://localhost:8080/api/car/search?brand=特斯拉"

echo -e "\n3. 价格区间搜索（20-30万）:"
curl -s "http://localhost:8080/api/car/search?minPrice=200000&maxPrice=300000"

echo -e "\n4. 续航搜索（>600km）:"
curl -s "http://localhost:8080/api/car/search?minRange=600"

echo -e "\n5. 排序测试（按价格降序）:"
curl -s "http://localhost:8080/api/car/search?sortBy=price_desc"

echo -e "\n6. 库存不足车辆:"
curl -s "http://localhost:8080/api/car/low-stock?threshold=5"

echo -e "\n7. 品牌列表:"
curl -s "http://localhost:8080/api/car/brands"

echo -e "\n8. 电池类型列表:"
curl -s "http://localhost:8080/api/car/battery-types"

echo -e "\n9. 测试添加新车（模拟）:"
cat > new_car.json << 'JSON'
{
  "name": "测试车型",
  "brand": "测试品牌",
  "rangeKm": 500,
  "batteryType": "三元锂电池",
  "price": 199999.99,
  "stock": 10
}
JSON
echo "新车数据已准备，实际添加需要POST请求"

echo -e "\n✅ 车辆管理模块测试完成"
echo "如果看到数据返回，说明模块工作正常！"
