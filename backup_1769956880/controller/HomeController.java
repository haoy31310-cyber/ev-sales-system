package com.evsales.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HomeController {
    
    @GetMapping("/")
    public String home() {
        return "🚗 新能源汽车销售系统 API 服务已启动 - " + System.currentTimeMillis();
    }
    
    @GetMapping("/ping")
    public String ping() {
        return "pong - " + System.currentTimeMillis();
    }
    
    @GetMapping("/health")
    public String health() {
        return "{\"status\":\"healthy\",\"timestamp\":" + System.currentTimeMillis() + "}";
    }
}
