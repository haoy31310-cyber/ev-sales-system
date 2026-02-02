package com.evsales.controller;

import com.evsales.entity.TestDrive;
import com.evsales.service.TestDriveService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/test-drive")
public class TestDriveController {
    
    @Autowired
    private TestDriveService testDriveService;
    
    // 1. 获取所有试驾记录
    @GetMapping("/list")
    public Map<String, Object> getAllTestDrives() {
        Map<String, Object> result = new HashMap<>();
        try {
            List<TestDrive> testDrives = testDriveService.getAllTestDrives();
            result.put("code", 200);
            result.put("message", "success");
            result.put("data", testDrives);
            result.put("total", testDrives.size());
        } catch (Exception e) {
            result.put("code", 500);
            result.put("message", "服务器错误: " + e.getMessage());
        }
        return result;
    }
    
    // 2. 根据状态获取试驾记录
    @GetMapping("/status/{status}")
    public Map<String, Object> getTestDrivesByStatus(@PathVariable String status) {
        Map<String, Object> result = new HashMap<>();
        try {
            List<TestDrive> testDrives = testDriveService.getTestDrivesByStatus(status);
            result.put("code", 200);
            result.put("message", "success");
            result.put("data", testDrives);
            result.put("status", status);
        } catch (Exception e) {
            result.put("code", 500);
            result.put("message", "服务器错误: " + e.getMessage());
        }
        return result;
    }
    
    // 3. 统计数据
    @GetMapping("/stats")
    public Map<String, Object> getTestDriveStats() {
        Map<String, Object> result = new HashMap<>();
        try {
            int total = testDriveService.getAllTestDrives().size();
            int pending = testDriveService.getPendingCount();
            
            result.put("code", 200);
            result.put("message", "success");
            result.put("total", total);
            result.put("pending", pending);
        } catch (Exception e) {
            result.put("code", 500);
            result.put("message", "服务器错误: " + e.getMessage());
        }
        return result;
    }
    
    // 4. 测试接口
    @GetMapping("/ping")
    public String ping() {
        return "Test drive module is working";
    }
}
