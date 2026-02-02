package com.evsales;

import org.springframework.web.bind.annotation.*;

@RestController
public class TestController {
    
    @GetMapping("/")
    public String home() {
        return "🚗 新能源汽车销售系统 API";
    }
    
    @GetMapping("/ping")
    public String ping() {
        return "pong";
    }
    
    @GetMapping("/test")
    public String test() {
        return "Test endpoint is working!";
    }
}
