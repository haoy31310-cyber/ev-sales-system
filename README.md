# ev-sales-system# 🚗 新能源汽车销售系统

基于 Spring Boot + MyBatis + MySQL 开发的新能源汽车销售管理系统。

## 📋 功能模块

### 管理员功能
- 车辆信息管理
- 库存与销售管理
- 促销活动管理
- 试驾预约审核

### 用户功能
- 车辆检索与筛选
- 车辆详情查看
- 试驾预约
- 订单管理

## 🛠️ 技术栈

- **后端**: Spring Boot 2.7.18, MyBatis, MySQL 8.0
- **开发环境**: GitHub Codespaces
- **构建工具**: Maven 3.8
- **Java版本**: 17

## 🚀 快速开始

### 方式一：使用 GitHub Codespaces（推荐）

1. 点击仓库的 "Code" 按钮
2. 选择 "Codespaces" 标签
3. 点击 "Create codespace on main"
4. 等待环境自动配置完成（约2-3分钟）

### 方式二：本地运行

```bash
# 克隆项目
git clone https://github.com/你的用户名/ev-sales-system.git

# 进入目录
cd ev-sales-system

# 创建数据库
mysql -u root -p < schema.sql
mysql -u root -p ev_sales < data.sql

# 运行项目
mvn spring-boot:run
