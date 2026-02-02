#!/bin/bash
echo "📊 路径分析报告"
echo "=============="

BASE_URL="http://localhost:8080"
declare -A PATHS

PATHS=(
    ["首页"]="/"
    ["Ping测试"]="/ping"
    ["车辆测试"]="/api/car/test"
    ["车辆列表"]="/api/car/list"
    ["车辆健康"]="/api/car/health"
    ["Spring健康检查"]="/actuator/health"
    ["Actuator根"]="/actuator"
    ["错误页面"]="/error"
)

echo "测试结果："
for name in "${!PATHS[@]}"; do
    path=${PATHS[$name]}
    echo -n "$name ($path) ... "
    
    response=$(curl -s -w "|HTTP_STATUS:%{http_code}" "${BASE_URL}${path}")
    http_status=$(echo $response | sed -e 's/.*HTTP_STATUS://')
    body=$(echo $response | sed -e 's/HTTP_STATUS:.*//')
    
    if [[ $http_status == 200 ]]; then
        echo -e "✅ 成功"
        echo "   响应: $(echo $body | head -c 50)..."
    elif [[ $http_status == 404 ]]; then
        echo -e "❌ 404"
    elif [[ $http_status == 000 ]]; then
        echo -e "🔌 连接失败"
    else
        echo -e "⚠️  $http_status"
    fi
    echo ""
done

echo "🎯 分析建议："
echo "1. 如果 /api/car/test 成功但 /api/car/list 失败，说明CarController存在但方法缺失"
echo "2. 如果 /ping 失败，TestController可能不存在"
echo "3. 如果 /actuator/* 失败，需要添加spring-boot-starter-actuator依赖"
