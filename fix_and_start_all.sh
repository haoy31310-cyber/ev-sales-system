#!/bin/bash
echo "🔧 修复和启动完整系统"
echo "==================="

# 1. 停止所有
echo "停止所有进程..."
pkill -9 -f spring-boot 2>/dev/null || true
pkill -9 -f java 2>/dev/null || true
sleep 2

# 2. 清理
echo "清理项目..."
mvn clean

# 3. 创建数据库配置
echo "创建数据库配置..."
mkdir -p src/main/resources

# 创建简单配置
cat > src/main/resources/application.yml << 'CONFIG'
server:
  port: 8080
spring:
  datasource:
    url: jdbc:h2:mem:evsales;DB_CLOSE_DELAY=-1
    driver-class-name: org.h2.Driver
    username: sa
    password: 
  h2:
    console:
      enabled: true
      path: /h2-console
mybatis:
  configuration:
    map-underscore-to-camel-case: true
logging:
  level:
    root: INFO
    com.evsales: DEBUG
CONFIG

# 4. 确保pom.xml有H2依赖
if ! grep -q "h2database" pom.xml; then
    echo "添加H2依赖到pom.xml..."
    cat > pom_temp.xml << 'POM'
<?xml version="1.0" encoding="UTF-8"?>
<project>
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.evsales</groupId>
    <artifactId>ev-sales-system</artifactId>
    <version>1.0</version>
    
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.7.18</version>
    </parent>
    
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.mybatis.spring.boot</groupId>
            <artifactId>mybatis-spring-boot-starter</artifactId>
            <version>2.3.1</version>
        </dependency>
        <dependency>
            <groupId>com.h2database</groupId>
            <artifactId>h2</artifactId>
            <scope>runtime</scope>
        </dependency>
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <optional>true</optional>
        </dependency>
    </dependencies>
    
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
POM
    mv pom_temp.xml pom.xml
fi

# 5. 编译
echo "编译项目..."
mvn compile

if [ $? -ne 0 ]; then
    echo "❌ 编译失败！"
    exit 1
fi

# 6. 启动
echo "启动Spring Boot..."
echo "========================================"
echo "🚀 应用启动中..."
echo "📡 访问: http://localhost:8080"
echo "📡 API测试: curl http://localhost:8080/ping"
echo "🛑 按 Ctrl+C 停止"
echo "========================================"

mvn spring-boot:run
