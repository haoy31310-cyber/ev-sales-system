package com.evsales.controller;

import org.springframework.web.bind.annotation.*;

@RestController
public class TestController {
    
    @GetMapping("/")
    public String home() {
        return """
            <!DOCTYPE html>
            <html>
            <head><title>新能源汽车销售系统</title></head>
            <body>
                <h1>🚗 新能源汽车销售系统 API</h1>
                <h2>可用接口：</h2>
                <ul>
                    <li><a href="/ping">/ping</a> - 连通性测试</li>
                    <li><a href="/api/car/test">/api/car/test</a> - 车辆API测试</li>
                    <li><a href="/api/car/list">/api/car/list</a> - 车辆列表</li>
                    <li><a href="/api/car/health">/api/car/health</a> - 服务健康检查</li>
                    <li><a href="/api/car/1">/api/car/1</a> - 获取车辆详情(ID=1)</li>
                </ul>
            </body>
            </html>
            """;
    }
    
    @GetMapping("/ping")
    public String ping() {
        return "pong";
    }
    
    @GetMapping("/status")
    public String status() {
        return "{\"status\":\"running\",\"timestamp\":" + System.currentTimeMillis() + "}";
    }
}
