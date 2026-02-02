#!/bin/bash
echo "🧪 最终测试 - 三个完整模块"
echo "========================"

echo "等待应用启动..."
sleep 8

echo "1. 基础测试:"
echo "首页:"
curl -s http://localhost:8080/ && echo ""

echo -e "\nping测试:"
curl -s http://localhost:8080/ping && echo ""

echo -e "\n2. 车辆管理模块:"
echo "车辆列表:"
curl -s "http://localhost:8080/api/car/list" | head -200

echo -e "\n品牌列表:"
curl -s "http://localhost:8080/api/car/brands"

echo -e "\n库存不足车辆:"
curl -s "http://localhost:8080/api/car/low-stock"

echo -e "\n搜索特斯拉:"
curl -s "http://localhost:8080/api/car/search?brand=特斯拉"

echo -e "\n3. 促销活动模块:"
echo "所有促销:"
curl -s "http://localhost:8080/api/promotion/list"

echo -e "\n进行中促销:"
curl -s "http://localhost:8080/api/promotion/active"

echo -e "\n车辆1的促销:"
curl -s "http://localhost:8080/api/promotion/car/1"

echo -e "\n4. 试驾预约模块:"
echo "所有试驾:"
curl -s "http://localhost:8080/api/test-drive/list"

echo -e "\n待审核试驾:"
curl -s "http://localhost:8080/api/test-drive/status/PENDING"

echo -e "\n试驾统计:"
curl -s "http://localhost:8080/api/test-drive/stats"

echo -e "\n5. 数据库控制台:"
echo "H2控制台: http://localhost:8080/h2-console"
echo "JDBC URL: jdbc:h2:mem:evsales"
echo "用户名: sa"
echo "密码: (空)"

echo -e "\n✅ 测试完成！"
echo "如果看到数据返回，说明你的三个模块都正常工作！"
