package com.evsales.service.impl;

import com.evsales.entity.TestDrive;
import com.evsales.mapper.TestDriveMapper;
import com.evsales.service.TestDriveService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class TestDriveServiceImpl implements TestDriveService {
    
    @Autowired
    private TestDriveMapper testDriveMapper;
    
    @Override
    public List<TestDrive> getAllTestDrives() {
        return testDriveMapper.findAll();
    }
    
    @Override
    public List<TestDrive> getTestDrivesByUserId(Long userId) {
        return testDriveMapper.findByUserId(userId);
    }
    
    @Override
    public List<TestDrive> getTestDrivesByStatus(String status) {
        return testDriveMapper.findByStatus(status);
    }
    
    @Override
    public TestDrive getTestDriveById(Long id) {
        return testDriveMapper.findById(id);
    }
    
    @Override
    @Transactional
    public boolean applyTestDrive(TestDrive testDrive) {
        // 设置默认状态
        if (testDrive.getStatus() == null) {
            testDrive.setStatus("PENDING");
        }
        
        // 检查时间是否冲突
        if (isTimeConflict(testDrive.getCarId(), testDrive.getDriveTime())) {
            return false;
        }
        
        return testDriveMapper.insert(testDrive) > 0;
    }
    
    @Override
    @Transactional
    public boolean updateTestDrive(TestDrive testDrive) {
        return testDriveMapper.update(testDrive) > 0;
    }
    
    @Override
    @Transactional
    public boolean reviewTestDrive(Long id, String status, String reviewNotes) {
        return testDriveMapper.updateStatus(id, status, reviewNotes) > 0;
    }
    
    @Override
    @Transactional
    public boolean deleteTestDrive(Long id) {
        return testDriveMapper.deleteById(id) > 0;
    }
    
    @Override
    public int getPendingCount() {
        return testDriveMapper.countPending();
    }
    
    @Override
    public boolean isTimeConflict(Long carId, LocalDateTime driveTime) {
        // 简化实现：检查同一车辆同一时间是否有试驾
        // 实际项目中可能需要更复杂的冲突检查
        List<TestDrive> testDrives = testDriveMapper.findAll();
        for (TestDrive td : testDrives) {
            if (td.getCarId().equals(carId) && 
                td.getDriveTime().isEqual(driveTime) &&
                !"REJECTED".equals(td.getStatus()) &&
                !"CANCELLED".equals(td.getStatus())) {
                return true;
            }
        }
        return false;
    }
    
    @Override
    public boolean isValidTestDrive(TestDrive testDrive) {
        if (testDrive == null) return false;
        if (testDrive.getDriveTime() == null) return false;
        
        // 试驾时间不能在过去
        return !testDrive.getDriveTime().isBefore(LocalDateTime.now());
    }
}
