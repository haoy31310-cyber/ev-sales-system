#!/bin/bash
echo "🔍 API错误诊断"
echo "============"

echo "1. 检查基础接口..."
echo "ping接口:"
curl -s -w " HTTP状态码: %{http_code}\n" http://localhost:8080/ping

echo -e "\n2. 检查车辆API..."
echo "车辆列表:"
curl -s -w " HTTP状态码: %{http_code}\n" "http://localhost:8080/api/car/list"

echo -e "\n3. 检查数据库连接..."
# 检查数据库表是否存在
echo "访问H2控制台: http://localhost:8080/h2-console"

echo -e "\n4. 查看应用中的Controller..."
echo "找到的Controller:"
find src/main/java -name "*Controller.java" -exec grep -l "@RestController\|@Controller" {} \;

echo -e "\n5. 检查MyBatis Mapper..."
echo "找到的Mapper:"
find src/main/java -name "*Mapper.java" -exec grep -l "@Mapper" {} \;

echo -e "\n6. 检查数据库表..."
# 如果有H2控制台，检查表结构
cat > check_tables.sql << 'SQL'
SHOW TABLES;
SELECT * FROM car LIMIT 3;
SELECT * FROM promotion LIMIT 3;
SELECT * FROM test_drive LIMIT 3;
SQL
echo "SQL检查脚本已创建: check_tables.sql"

echo -e "\n7. 常见的API错误原因:"
echo "  1. Controller路径不正确"
echo "  2. 数据库表不存在"
echo "  3. MyBatis Mapper配置错误"
echo "  4. Service或Mapper注入失败"
