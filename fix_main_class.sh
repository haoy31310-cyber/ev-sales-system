#!/bin/bash
echo "🔧 修复Spring Boot主类问题"
echo "========================"

echo "1. 清理多余的主类..."
find src/main/java -name "*.java" -exec grep -l "public static void main" {} \; > main_classes.txt
echo "找到的主类："
cat main_classes.txt

# 保留Application.java，删除其他
grep -v "Application.java" main_classes.txt | while read file; do
    echo "删除: $file"
    rm "$file" 2>/dev/null || true
done

echo "2. 确保只有一个主类..."
if [ ! -f "src/main/java/com/evsales/Application.java" ]; then
    echo "创建Application.java..."
    mkdir -p src/main/java/com/evsales
    cat > src/main/java/com/evsales/Application.java << 'APP'
package com.evsales;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
APP
fi

echo "3. 更新pom.xml..."
# 创建临时的pom更新脚本
cat > update_pom.xml << 'POM_UPDATE'
<project>
  <build>
    <plugins>
      <plugin>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-maven-plugin</artifactId>
        <configuration>
          <mainClass>com.evsales.Application</mainClass>
        </configuration>
      </plugin>
    </plugins>
  </build>
</project>
POM_UPDATE

# 使用xmlstarlet更新，如果没有则简单替换
if command -v xmlstarlet &> /dev/null; then
    xmlstarlet ed -L \
        -s "/project/build/plugins/plugin[artifactId='spring-boot-maven-plugin']" -t elem -n configuration \
        -s "/project/build/plugins/plugin[artifactId='spring-boot-maven-plugin']/configuration" -t elem -n mainClass -v "com.evsales.Application" \
        pom.xml
else
    # 简单方法：在插件配置中添加mainClass
    sed -i 's|<artifactId>spring-boot-maven-plugin</artifactId>|<artifactId>spring-boot-maven-plugin</artifactId>\n                <configuration>\n                    <mainClass>com.evsales.Application</mainClass>\n                </configuration>|' pom.xml
fi

echo "4. 重新编译..."
mvn clean compile

echo "✅ 修复完成！现在可以运行: mvn spring-boot:run"
