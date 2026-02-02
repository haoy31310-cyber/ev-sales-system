#!/bin/sh
echo "🐬 Alpine MariaDB启动脚本"
echo "========================"

# 停止任何已有的MariaDB进程
echo "1. 停止已有进程..."
sudo pkill -f mariadbd 2>/dev/null || true
sudo pkill -f mysqld 2>/dev/null || true
sleep 2

# 检查数据目录
echo "2. 检查数据目录..."
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "初始化MariaDB数据库..."
    sudo mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# 启动MariaDB
echo "3. 启动MariaDB..."
sudo mariadbd --user=mysql &
# 或使用: sudo mysqld_safe --user=mysql &

# 等待启动
echo "等待启动..."
for i in {1..10}; do
    if mysql -u root -e "SELECT 1;" 2>/dev/null; then
        echo "✅ MariaDB启动成功！"
        break
    fi
    echo -n "."
    sleep 1
    if [ $i -eq 10 ]; then
        echo "❌ MariaDB启动超时"
        exit 1
    fi
done

# 配置数据库
echo "4. 配置数据库..."
mysql -u root -e "CREATE DATABASE IF NOT EXISTS ev_sales;" 2>/dev/null || {
    echo "设置root密码为空..."
    sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '';"
    sudo mysql -e "FLUSH PRIVILEGES;"
    mysql -u root -e "CREATE DATABASE IF NOT EXISTS ev_sales;"
}

# 导入数据
echo "5. 导入数据..."
[ -f "schema.sql" ] && mysql -u root ev_sales < schema.sql 2>/dev/null && echo "✅ 导入表结构"
[ -f "data.sql" ] && mysql -u root ev_sales < data.sql 2>/dev/null && echo "✅ 导入测试数据"

echo -e "\n🎉 MariaDB配置完成！"
echo "测试: mysql -u root ev_sales -e 'SHOW TABLES;'"
