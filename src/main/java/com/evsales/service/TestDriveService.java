package com.evsales.service;

import com.evsales.entity.TestDrive;
import java.time.LocalDateTime;
import java.util.List;

public interface TestDriveService {
    
    // 获取所有试驾预约
    List<TestDrive> getAllTestDrives();
    
    // 根据用户ID获取试驾记录
    List<TestDrive> getTestDrivesByUserId(Long userId);
    
    // 根据状态获取试驾记录
    List<TestDrive> getTestDrivesByStatus(String status);
    
    // 根据ID获取试驾记录
    TestDrive getTestDriveById(Long id);
    
    // 申请试驾
    boolean applyTestDrive(TestDrive testDrive);
    
    // 更新试驾信息
    boolean updateTestDrive(TestDrive testDrive);
    
    // 审核试驾申请
    boolean reviewTestDrive(Long id, String status, String reviewNotes);
    
    // 删除试驾记录
    boolean deleteTestDrive(Long id);
    
    // 获取待审核数量
    int getPendingCount();
    
    // 检查试驾时间是否冲突
    boolean isTimeConflict(Long carId, LocalDateTime driveTime);
    
    // 检查试驾申请是否有效
    boolean isValidTestDrive(TestDrive testDrive);
}
