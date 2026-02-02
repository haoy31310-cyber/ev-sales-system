package com.evsales;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        System.out.println("==================================");
        System.out.println("🚗 新能源汽车销售系统");
        System.out.println("==================================");
        SpringApplication.run(Application.class, args);
    }
}
