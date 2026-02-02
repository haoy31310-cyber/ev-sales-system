#!/bin/bash
echo "🔧 修复重复的Bean定义"
echo "=================="

echo "1. 清理根目录的错误Controller文件..."
ERROR_FILES=$(find src/main/java/com/evsales -maxdepth 1 -name "*Controller.java" -type f)
if [ -n "$ERROR_FILES" ]; then
    echo "找到错误的Controller文件:"
    echo "$ERROR_FILES"
    echo "正在删除..."
    rm -f $ERROR_FILES
    echo "✅ 已删除"
else
    echo "✅ 没有错误的Controller文件"
fi

echo -e "\n2. 检查正确的Controller位置..."
mkdir -p src/main/java/com/evsales/controller

echo "controller包中的文件:"
ls -la src/main/java/com/evsales/controller/ 2>/dev/null || echo "controller目录为空"

echo -e "\n3. 检查Service和Mapper..."
echo "service包:"
find src/main/java/com/evsales/service -name "*.java" 2>/dev/null | wc -l | xargs echo "文件数:"

echo "mapper包:"
find src/main/java/com/evsales/mapper -name "*.java" 2>/dev/null | wc -l | xargs echo "文件数:"

echo -e "\n4. 检查Application主类..."
MAIN_CLASSES=$(find src/main/java/com/evsales -name "*.java" -exec grep -l "public static void main" {} \; 2>/dev/null)
if [ $(echo "$MAIN_CLASSES" | wc -l) -gt 1 ]; then
    echo "⚠️  发现多个主类:"
    echo "$MAIN_CLASSES"
    echo "建议只保留一个: Application.java"
else
    echo "✅ 主类正常"
fi

echo -e "\n5. 重新编译..."
mvn clean compile 2>&1 | tail -10

if [ $? -eq 0 ]; then
    echo "✅ 编译成功！"
    echo ""
    echo "🚀 现在可以启动应用："
    echo "mvn spring-boot:run"
else
    echo "❌ 编译失败"
    mvn compile 2>&1 | grep -i "error" -B2 -A2 | head -20
fi
