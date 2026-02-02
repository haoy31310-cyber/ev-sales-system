package com.evsales.entity;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class Car {
    private Long id;
    private String name;
    private String brand;
    private String model;
    private Integer rangeKm;
    private String batteryType;
    private BigDecimal price;
    private Integer stock;
    private LocalDate releaseDate;
    private Integer fastChargeTime;
    private String autonomousLevel;
    private String description;
    private String imageUrl;
    private Integer status;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
