#!/bin/bash
echo "🧪 立即测试API"
echo "============="

BASE_URL="http://localhost:8080"

echo "1. 测试服务是否运行..."
if curl -s -o /dev/null -w "%{http_code}" "$BASE_URL" | grep -q "200\|404"; then
    echo "✅ Spring Boot服务运行中"
else
    echo "❌ 服务未运行"
    echo "请先运行: mvn spring-boot:run"
    exit 1
fi

echo -e "\n2. 测试车辆列表接口..."
curl -s "$BASE_URL/api/car/list" | head -100

echo -e "\n3. 测试数据库连接..."
echo "检查车辆表数据:"
mysql -u root ev_sales -e "SELECT id, name, brand, price FROM car LIMIT 5;" 2>/dev/null || echo "数据库查询失败"

echo -e "\n4. 查看Spring Boot日志最后几行..."
tail -n 5 /workspaces/ev-sales-system/spring.log 2>/dev/null || echo "日志文件不存在"

echo -e "\n✅ 测试完成！"
