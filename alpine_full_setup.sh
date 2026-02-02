#!/bin/sh
echo "🔧 Alpine Linux完整环境设置"
echo "============================"

set -e  # 出错时停止

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 检查并安装软件
install_package() {
    echo -n "检查 $1... "
    if apk info -e $1 >/dev/null 2>&1; then
        echo -e "${GREEN}已安装${NC}"
    else
        echo -e "${YELLOW}安装中...${NC}"
        sudo apk add $1
    fi
}

echo "1. 安装基础软件包..."
install_package openjdk17
install_package maven
install_package mysql
install_package mysql-client
install_package openrc
install_package net-tools

echo -e "\n2. 初始化MySQL..."
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "初始化MySQL数据库..."
    sudo mysql_install_db --user=mysql --datadir=/var/lib/mysql
    echo -e "${GREEN}✅ 数据库初始化完成${NC}"
fi

echo -e "\n3. 配置OpenRC..."
sudo openrc boot >/dev/null 2>&1

echo -e "\n4. 启动MySQL..."
# 尝试多种启动方式
if sudo rc-service mysql start 2>/dev/null; then
    echo -e "${GREEN}✅ 使用rc-service启动成功${NC}"
elif sudo /etc/init.d/mysql start 2>/dev/null; then
    echo -e "${GREEN}✅ 使用init.d启动成功${NC}"
else
    echo -e "${YELLOW}尝试直接启动mysqld...${NC}"
    sudo mysqld --user=mysql --daemonize
fi

# 等待MySQL启动
sleep 3

echo -e "\n5. 配置MySQL root用户..."
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '';" 2>/dev/null || true
sudo mysql -e "FLUSH PRIVILEGES;" 2>/dev/null || true

echo -e "\n6. 创建项目数据库..."
mysql -u root -e "CREATE DATABASE IF NOT EXISTS ev_sales;" 2>/dev/null || {
    echo -e "${YELLOW}重新配置MySQL权限...${NC}"
    sudo mysql -e "UPDATE mysql.user SET plugin='mysql_native_password', authentication_string='' WHERE User='root';"
    sudo mysql -e "FLUSH PRIVILEGES;"
    mysql -u root -e "CREATE DATABASE IF NOT EXISTS ev_sales;"
}

echo -e "\n7. 导入数据..."
[ -f "schema.sql" ] && mysql -u root ev_sales < schema.sql 2>/dev/null && echo -e "${GREEN}✅ 导入表结构${NC}"
[ -f "data.sql" ] && mysql -u root ev_sales < data.sql 2>/dev/null && echo -e "${GREEN}✅ 导入测试数据${NC}"

echo -e "\n${GREEN}🎉 环境设置完成！${NC}"
echo "Java版本: $(java -version 2>&1 | head -1)"
echo "Maven版本: $(mvn -v 2>&1 | head -1)"
echo "MySQL版本: $(mysql --version 2>&1 | head -1)"
echo ""
echo "现在可以运行: mvn spring-boot:run"
