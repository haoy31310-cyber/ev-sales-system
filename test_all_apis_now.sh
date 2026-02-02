#!/bin/bash
echo "🧪 测试所有API接口"
echo "================"

echo "等待应用完全启动..."
sleep 5

echo "1. 基础健康检查："
echo "ping接口:"
curl -s http://localhost:8080/ping && echo ""

echo -e "\n2. 车辆管理模块测试："
echo "2.1 获取所有车辆："
curl -s "http://localhost:8080/api/car/list" | head -200

echo -e "\n2.2 获取车辆详情（含促销）："
curl -s "http://localhost:8080/api/car/detail/1"

echo -e "\n2.3 条件搜索车辆："
curl -s "http://localhost:8080/api/car/search?brand=特斯拉"

echo -e "\n2.4 获取所有品牌："
curl -s "http://localhost:8080/api/car/brands"

echo -e "\n2.5 库存不足车辆："
curl -s "http://localhost:8080/api/car/low-stock"

echo -e "\n\n3. 促销活动模块测试："
echo "3.1 获取所有促销活动："
curl -s "http://localhost:8080/api/promotion/list"

echo -e "\n3.2 获取进行中的促销："
curl -s "http://localhost:8080/api/promotion/active"

echo -e "\n3.3 获取车辆的促销活动："
curl -s "http://localhost:8080/api/promotion/car/1"

echo -e "\n\n4. 试驾预约模块测试："
echo "4.1 获取所有试驾记录："
curl -s "http://localhost:8080/api/test-drive/list"

echo -e "\n4.2 获取待审核试驾："
curl -s "http://localhost:8080/api/test-drive/status/PENDING"

echo -e "\n4.3 试驾统计数据："
curl -s "http://localhost:8080/api/test-drive/stats"

echo -e "\n\n5. H2数据库控制台："
echo "访问: http://localhost:8080/h2-console"
echo "JDBC URL: jdbc:h2:mem:evsales"
echo "用户名: sa"
echo "密码: (空)"

echo -e "\n✅ 所有模块测试完成！"
echo "如果看到数据返回，说明你的三个模块都工作正常！"
