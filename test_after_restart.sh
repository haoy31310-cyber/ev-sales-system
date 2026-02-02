#!/bin/bash
echo "🧪 重启后API测试"
echo "=============="

BASE_URL="http://localhost:8080"
WAIT_TIME=15

echo "等待Spring Boot完全启动 ($WAIT_TIME秒)..."
sleep $WAIT_TIME

echo -e "\n开始测试：\n"

# 测试数组
declare -A tests
tests["首页"]="/"
tests["连通性测试"]="/ping"
tests["车辆测试接口"]="/api/car/test"
tests["车辆列表接口"]="/api/car/list"
tests["促销测试接口"]="/api/promotion/test"
tests["促销列表接口"]="/api/promotion/list"

all_success=true

for name in "${!tests[@]}"; do
    path="${tests[$name]}"
    echo -n "测试 $name ($path)... "
    
    response=$(timeout 5 curl -s -w "|STATUS:%{http_code}" "${BASE_URL}${path}" 2>/dev/null)
    
    if [ $? -eq 0 ]; then
        http_status=$(echo $response | sed -e 's/.*STATUS://')
        body=$(echo $response | sed -e 's/STATUS:.*//')
        
        if [[ $http_status == 200 ]]; then
            echo "✅ 成功"
            echo "   响应: $(echo $body | head -c 50)..."
        elif [[ $http_status == 404 ]]; then
            echo "❌ 404 (接口不存在)"
            all_success=false
        else
            echo "⚠️  HTTP $http_status"
            echo "   响应: $(echo $body | head -c 50)..."
        fi
    else
        echo "❌ 请求超时或失败"
        all_success=false
    fi
    echo ""
done

echo "📊 测试结果汇总："
if $all_success; then
    echo "🎉 所有API测试成功！可以开始开发业务功能。"
else
    echo "⚠️  部分API测试失败，需要创建对应的Controller。"
    echo "建议先创建基本的Controller确保API可用。"
fi
