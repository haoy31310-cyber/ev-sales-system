#!/bin/bash
echo "🧪 测试运行中的Spring Boot API"
echo "=========================="

echo "等待应用完全启动..."
sleep 3

echo "1. 基础健康检查："
curl -s http://localhost:8080/ping && echo ""

echo -e "\n2. 首页："
curl -s http://localhost:8080/

echo -e "\n\n3. 测试车辆管理模块："
echo "3.1 获取所有车辆："
curl -s "http://localhost:8080/api/car/list" | head -200

echo -e "\n3.2 获取所有品牌："
curl -s "http://localhost:8080/api/car/brands"

echo -e "\n3.3 查询特斯拉车辆："
curl -s "http://localhost:8080/api/car/search?brand=特斯拉"

echo -e "\n3.4 查看库存不足车辆："
curl -s "http://localhost:8080/api/car/low-stock?threshold=10"

echo -e "\n3.5 测试H2数据库控制台："
echo "在浏览器中打开：http://localhost:8080/h2-console"
echo "JDBC URL: jdbc:h2:mem:evsales"
echo "用户名: sa"
echo "密码: (空)"

echo -e "\n✅ API测试完成！"
echo "如果看到车辆数据，说明车辆管理模块工作正常！"
