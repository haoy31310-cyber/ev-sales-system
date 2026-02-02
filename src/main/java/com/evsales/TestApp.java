package com.evsales;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class TestApp {
    public static void main(String[] args) {
        System.out.println("TestApp starting...");
        SpringApplication.run(TestApp.class, args);
        System.out.println("TestApp started!");
    }
}
