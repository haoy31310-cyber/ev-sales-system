#!/bin/bash
echo "🚘 创建试驾预约模块"
echo "================"

# 1. 创建试驾预约实体
cat > src/main/java/com/evsales/entity/TestDrive.java << 'TESTDRIVE'
package com.evsales.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class TestDrive {
    private Long id;
    private Long userId;        // 用户ID
    private Long carId;         // 车辆ID
    private String store;       // 试驾门店
    private LocalDateTime driveTime; // 试驾时间
    private String status;      // 状态: PENDING, APPROVED, REJECTED, COMPLETED
    private String notes;       // 备注
    private LocalDateTime applyTime; // 申请时间
    private LocalDateTime reviewTime; // 审核时间
    private String reviewNotes; // 审核意见
}
TESTDRIVE

# 2. 创建TestDriveMapper
cat > src/main/java/com/evsales/mapper/TestDriveMapper.java << 'TMAPPER'
package com.evsales.mapper;

import com.evsales.entity.TestDrive;
import org.apache.ibatis.annotations.*;
import java.time.LocalDateTime;
import java.util.List;

@Mapper
public interface TestDriveMapper {
    
    // 查询所有试驾预约
    @Select("SELECT * FROM test_drive ORDER BY apply_time DESC")
    List<TestDrive> findAll();
    
    // 根据用户ID查询
    @Select("SELECT * FROM test_drive WHERE user_id = #{userId} ORDER BY apply_time DESC")
    List<TestDrive> findByUserId(Long userId);
    
    // 根据状态查询
    @Select("SELECT * FROM test_drive WHERE status = #{status} ORDER BY apply_time DESC")
    List<TestDrive> findByStatus(String status);
    
    // 根据ID查询
    @Select("SELECT * FROM test_drive WHERE id = #{id}")
    TestDrive findById(Long id);
    
    // 插入试驾预约
    @Insert("INSERT INTO test_drive (user_id, car_id, store, drive_time, status, notes) " +
            "VALUES (#{userId}, #{carId}, #{store}, #{driveTime}, #{status}, #{notes})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(TestDrive testDrive);
    
    // 更新试驾状态（管理员审核）
    @Update("UPDATE test_drive SET status = #{status}, review_time = NOW(), review_notes = #{reviewNotes} WHERE id = #{id}")
    int updateStatus(@Param("id") Long id, @Param("status") String status, @Param("reviewNotes") String reviewNotes);
    
    // 更新试驾信息
    @Update("UPDATE test_drive SET store = #{store}, drive_time = #{driveTime}, notes = #{notes} WHERE id = #{id}")
    int update(TestDrive testDrive);
    
    // 删除试驾预约
    @Delete("DELETE FROM test_drive WHERE id = #{id}")
    int deleteById(Long id);
    
    // 统计待审核的试驾申请
    @Select("SELECT COUNT(*) FROM test_drive WHERE status = 'PENDING'")
    int countPending();
}
TMAPPER

# 3. 创建数据库表
cat > test_drive_schema.sql << 'SQL'
-- 试驾预约表
CREATE TABLE IF NOT EXISTS test_drive (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    car_id BIGINT NOT NULL,
    store VARCHAR(100) NOT NULL,
    drive_time DATETIME NOT NULL,
    status VARCHAR(20) DEFAULT 'PENDING',
    notes TEXT,
    apply_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    review_time DATETIME,
    review_notes TEXT,
    INDEX idx_user (user_id),
    INDEX idx_status (status),
    INDEX idx_time (drive_time),
    FOREIGN KEY (car_id) REFERENCES car(id) ON DELETE CASCADE
);

-- 插入测试数据（假设用户ID 1001-1005）
INSERT INTO test_drive (user_id, car_id, store, drive_time, status) VALUES
(1001, 1, '北京特斯拉体验中心', '2024-02-10 14:00:00', 'APPROVED'),
(1002, 2, '上海特斯拉中心', '2024-02-12 10:30:00', 'PENDING'),
(1003, 3, '深圳比亚迪4S店', '2024-02-15 15:00:00', 'APPROVED'),
(1004, 1, '广州特斯拉体验店', '2024-02-08 11:00:00', 'COMPLETED');

SELECT '试驾预约表:' AS '';
SELECT * FROM test_drive;
SQL

echo "✅ 试驾预约模块代码已创建！"
echo "数据库脚本: test_drive_schema.sql"
echo "实体类: TestDrive.java"
echo "Mapper: TestDriveMapper.java"
